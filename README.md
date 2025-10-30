# SecurityTest (Spring MVC + Spring Security)

Spring MVC 환경에 Spring Security를 적용하여 인증(Authentication) 및 허가(Authorization)를 구현한 기본 예제

## 📖 About

Spring MVC 프로젝트에 Spring Security를 적용한 보안 학습 예제

이 프로젝트는 **JDBC 인증**을 기반으로 `BCrypt` 암호화를 사용
Spring Security의 기본 DB 스키마 대신 **커스텀 DB 스키마**(`member`, `member_auth` 테이블)를 적용하는 방법을 구현


`UserDetailsService`를 직접 구현(`CustomUserDetailsService`)하여, 로그인 시 `MemberDTO`의 전체 정보를 커스텀 `Principal` 객체(`CustomUser`)에 담아 관리

## 🚀 주요 구현 기능

* **회원가입:**
    * 회원가입 기능 구현 (`/register.do`).
    * `BCryptPasswordEncoder`를 사용해 비밀번호를 암호화하여 `member` 테이블에 저장.
    * `member_auth` 테이블에 사용자의 권한(`ROLE_MEMBER`, `ROLE_ADMIN`)을 별도 저장.
* **인증 (Authentication):**
    * `UserDetailsService`를 커스텀 구현 (`CustomUserDetailsService`)하여 `security-context.xml`에 등록.
    * 로그인 시 `member`와 `member_auth`를 조인(join)하여 `CustomUser` 객체 생성.
* **커스텀 DTO:**
    * Spring `User`를 상속받은 `CustomUser` 객체를 사용.
    * 로그인 후 `principal` 객체에서 `MemberDTO`의 상세 정보(`membername`, `email` 등)에 접근 가능.
* **허가 (Authorization):**
    * URL 패턴(`intercept-url`) 및 JSP 태그(`sec:authorize`)를 사용한 접근 제어.
* **커스텀 핸들러:**
    * **Custom Login Page:** 기본 로그인 페이지 대신 `customlogin.jsp` 사용.
    * **Custom Logout Page:** `customlogout.jsp`를 통한 로그아웃 수행.
    * **Login Success Handler:** `CustomLoginSuccessHandler` 구현. (로그인 성공 시 사용자가 원래 접근하려던 페이지로 리다이렉트)
    * **Access Denied Handler:** `CustomAccessDeniedHandler` 구현. (403 에러 커스텀 페이지로 처리)
* **CSRF:**
    * CSRF 보호 기능 활성화. `login`, `logout` 폼에 CSRF 토큰 포함.
---

## ⚙️ 핵심 설정

### 1. 인증 관리자 (`security-context.xml`)

`UserDetailsService`의 커스텀 구현체인 `customUserDetailsService`를 `authentication-provider`에 등록하여 인증을 처리합니다. 비밀번호는 `bCryptPasswordEncoder`를 사용해 비교합니다.

```xml
<bean id="customUserDetailsService" class="com.test.java.auth.CustomUserDetailsService"></bean>

<security:authentication-manager>
    <security:authentication-provider user-service-ref="customUserDetailsService">
        <security:password-encoder ref="bCryptPasswordEncoder" />
    </security:authentication-provider>
</security:authentication-manager>

<bean id="bCryptPasswordEncoder" class="org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder"></bean>

```

### 2. MyBatis (MamberMapper.xml)
CustomUserDetailsService가 member와 member_auth 테이블을 1:N 조인(Join)하기 위해 resultMap을 사용.

```xml
<resultMap type="com.test.java.model.AuthDTO" id="authMap">
    <result column="amemberid" property="memberid" />
    <result column="auth" property="auth" />
</resultMap>

<resultMap type="com.test.java.model.MemberDTO" id="memberMap">
    <id column="memberid" property="memberid" />
    <result column="memberpw" property="memberpw" />
    <result column="membername" property="membername" />
    ...
    <collection property="authList" resultMap="authMap"></collection>
</resultMap>

<select id="get" parameterType="String" resultMap="memberMap">
    select
        m.*,
        a.*,
        m.memberid as memberid,
        a.memberid as amemberid
    from member m
        inner join member_auth a
            on m.memberid = a.memberid
                where m.memberid = #{username}
</select>

```

### 3. HTTP 보안 설정 (security-context.xml)
* **/index.do: permitAll (모두 허용).

* **/member.do: hasRole('ROLE_MEMBER') (멤버 권한).

* **/admin.do: hasRole('ROLE_ADMIN') (관리자 권한).

* **커스텀 로그인 페이지(/customlogin.do) 및 로그인 성공 핸들러(customLoginSuccessHandler) 지정.

* **커스텀 로그아웃 URL(/customlogout.do) 및 로그아웃 성공 시 이동 URL(/index.do) 지정.

--

💻 UI 보안 (JSP Taglibs)
Spring Security Taglibs를 사용해 로그인 상태 및 권한에 따라 화면 요소 동적 제어.
TooManyResultsException과 NullPointerException을 해결하기 위해 resultMap을 사용.

* **로그인 상태별 분기:

  * **isAnonymous(): 비로그인 사용자에게 "Login" 링크 노출. 

  * **isAuthenticated(): 로그인 사용자에게 "Logout" 링크 및 사용자 ID 노출. 

* **권한별 분기:

  * **hasRole('ROLE_MEMBER'): ROLE_MEMBER 권한 사용자에게 "Member" 링크 노출. 

  * **hasRole('ROLE_ADMIN'): ROLE_ADMIN 권한 사용자에게 "Admin" 링크 노출.

* **CustomUser 객체를 사용하므로, principal에서 mdto 프로퍼티를 통해 membername 등 부가 정보에 접근가능

```Java

<%-- 로그인 상태일 때 --%>
<sec:authorize access="isAuthenticated()">
    <h1>
        Spring Security 
        <small style="color: cornflowerblue;">
            <sec:authentication property="principal.username"/>
        </small>
    </h1>
    <li><a href="/java/customlogout.do">Logout</a></li>
</sec:authorize>

<%-- member.jsp에서 CustomUser의 DTO 정보 접근 --%>
<div class="message" title="사용자 이름">
    <sec:authentication property="principal.mdto.membername"/>
</div>
<div class="message" title="사용자 이메일">
    <sec:authentication property="principal.mdto.email"/>
</div>
```
--
🧪 테스트 (JUnit)
* **AddMember.java 테스트 클래스를 사용해 BCrypt로 암호화된 테스트 회원 데이터를 member 및 member_auth 테이블에 삽입.

* **테스트 시 @WebAppConfiguration 어노테이션을 사용해 servlet-context.xml 로드.
