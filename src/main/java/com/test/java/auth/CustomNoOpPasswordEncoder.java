package com.test.java.auth;

import org.springframework.security.crypto.password.PasswordEncoder;

public class CustomNoOpPasswordEncoder implements PasswordEncoder {

	/*
	 	
	 	1. 회원 가입 
	 		- hong, 1111 > 사용자 입력
	 		- DB 저장 > 암호화
	 			- "1111" > "AS23VW31" > DB저장
	 			
	 	2. 로그인
	 		- hong, 1111 > 사용자 입력
	 		- where 1111 = "AS23VW31" 
	 		
	 */
	
	@Override
	public String encode(CharSequence rawPassword) {
		//사용자가 입력한 암호 > (암호화) > 반환
		System.out.println("원래 암호:" + rawPassword);
		
		return rawPassword.toString();
	}

	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		
		//사용자가 입력한 암호 VS 인코딩된 암호
		
		System.out.println("암호 비교:" + rawPassword + "," + encodedPassword);
		
		return rawPassword.toString().equals(encodedPassword);
	}

	
}
