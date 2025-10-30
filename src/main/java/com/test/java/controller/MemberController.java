package com.test.java.controller;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.test.java.model.AuthDTO;
import com.test.java.model.MemberDTO;
import com.test.java.model.MemberMapper;

import lombok.RequiredArgsConstructor;

/*
 	스프링 빈 만들기
 	
 	1. XML 방식
 	- <bean clss="com.test.java.MemberController" id="m1">
 	
 	2. 어노테이션 방식 > memberController
 	- @Component("m1)
 	  public class MemberController {}
 
 
 */

@Controller
@RequiredArgsConstructor
public class MemberController {
	
	private final MemberMapper mapper;
	private final BCryptPasswordEncoder encoder;
	
	@GetMapping("/register.do")
	public String register( ) {
		return "register";
	}

	@PostMapping("/registerok.do")
	public String registerok(MemberDTO dto, String auth) {
		
		//403 발생 원인
		//1. 권한 부족
		//2. POST 요청 + CSRF 토큰이 없을때
		
		//입력한 암호 > 암호화 > 회원가입
		
		//회원 정보 추가
		dto.setMemberpw(encoder.encode(dto.getMemberpw()));
		mapper.add(dto);
		
		//회원 권한 추가
		//1. 일반 회원 > ROLE_MEMBER
		//2. 관리자 > ROLE_ADMIN, ROLE_MEMBER
		if (auth.equals("1") || auth.equals("2")) {
			//권한 + 누구?
			AuthDTO adto = new AuthDTO();
			adto.setMemberid(dto.getMemberid());
			adto.setAuth("ROLE_MEMBER");
			mapper.addAuth(adto);
		}

		if (auth.equals("2")) {
			//권한 + 누구?
			AuthDTO adto = new AuthDTO();
			adto.setMemberid(dto.getMemberid());
			adto.setAuth("ROLE_ADMIN");
			mapper.addAuth(adto);
		}
	
		return "registerok";
	}

}
