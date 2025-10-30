# SecurityTest (Spring MVC + Spring Security)

Spring MVC 환경에 Spring Security를 적용하여 인증(Authentication) 및 허가(Authorization)를 구현한 기본 예제.

## 🚀 주요 구현 기능

* **인증:** JDBC 기반 인증 사용.
* **허가:** URL 패턴(`intercept-url`) 및 JSP 태그(`sec:authorize`)를 사용한 접근 제어.
* **데이터베이스:** Spring Security 기본 스키마 대신, `member`, `member_auth` 테이블을 사용하는 커스텀 DB 스키마 적용.
* **비밀번호 암호화:** `BCryptPasswordEncoder`를 사용해 회원 비밀번호 암호화.
* **커스텀 핸들러:**
    * **Custom Login Page:** 기본 로그인 페이지 대신 `customlogin.jsp` 사용.
    * **Custom Logout Page:** `customlogout.jsp`를 통한 로그아웃 수행.
    * **Login Success Handler:** `CustomLoginSuccessHandler` 구현. (로그인 성공 시 사용자가 원래 접근하려던 페이지로 리다이렉트)
    * **Access Denied Handler:** `CustomAccessDeniedHandler` 구현. (403 에러 커스텀 페이지로 처리)
* **CSRF:** CSRF 보호 기능 활성화. `login`, `logout` 폼에 CSRF 토큰 포함.

---

## ⚙️ 핵심 설정 (`security-context.xml`)

### 1. 인증 관리자 (Authentication Manager)

* `security:jdbc-user-service`를 사용해 DB 연동.
* `users-by-username-query` 및 `authorities-by-username-query`에 커스텀 쿼리 지정. (`member`, `member_auth` 테이블 사용)
* 비밀번호 인코더로 `bCryptPasswordEncoder` 빈 참조.

```xml
<security:authentication-manager>
    <security:authentication-provider>
        <security:jdbc-user-service data-source-ref="dataSource" 
            users-by-username-query="select memberid as username, memberpw as password, enabled from member where memberid = ?" 
            authorities-by-username-query="select memberid as username, auth as authority from member_auth where memberid = ?"/>
        <security:password-encoder ref="bCryptPasswordEncoder" />
    </security:authentication-provider>
</security:authentication-manager>

```
### 2. HTTP 보안 설정
* **/index.do: permitAll (모두 허용).

* **/member.do: hasRole('ROLE_MEMBER') (멤버 권한).

* **/admin.do: hasRole('ROLE_ADMIN') (관리자 권한).

* **커스텀 로그인 페이지(/customlogin.do) 및 로그인 성공 핸들러(customLoginSuccessHandler) 지정.

* **커스텀 로그아웃 URL(/customlogout.do) 및 로그아웃 성공 시 이동 URL(/index.do) 지정.

--

💻 UI 보안 (JSP Taglibs)
Spring Security Taglibs를 사용해 로그인 상태 및 권한에 따라 화면 요소 동적 제어.

* **로그인 상태별 분기:

  * **isAnonymous(): 비로그인 사용자에게 "Login" 링크 노출. 

  * **isAuthenticated(): 로그인 사용자에게 "Logout" 링크 및 사용자 ID 노출. 

* **권한별 분기:

  * **hasRole('ROLE_MEMBER'): ROLE_MEMBER 권한 사용자에게 "Member" 링크 노출. 

  * **hasRole('ROLE_ADMIN'): ROLE_ADMIN 권한 사용자에게 "Admin" 링크 노출. 

```Java

<%-- 로그인 상태일 때 --%>
<sec:authorize access="isAuthenticated()">
    <h1>
        Spring Security 
        <small><sec:authentication property="principal.username"/></small>
    </h1>
    <li><a href="/java/customlogout.do">Logout</a></li>
</sec:authorize>

<%-- 권한이 있을 때 --%>
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <li><a href="/java/admin.do">Admin</a></li>
</sec:authorize>
```
--
🧪 테스트 (JUnit)
* **AddMember.java 테스트 클래스를 사용해 BCrypt로 암호화된 테스트 회원 데이터를 member 테이블에 삽입.

* **테스트 시 @WebAppConfiguration 어노테이션을 사용해 servlet-context.xml 로드.
