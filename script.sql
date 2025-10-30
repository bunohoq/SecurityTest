-- SecurityTest

-- 시큐리티
create table users (
	username varchar2(50) not null primary key,     -- 아이디
	password varchar2(50) not null,                 -- 암호
	enabled char(1) default '1'                     -- 활동/미활동
);

create table authorities (
	username varchar2(50) not null,                 -- 아이디(FK)
	authority varchar2(50) not null,                -- 권한 (ROLE_XXXX)
	constraint fk_authorities_users foreign key(username) references users(username)
);

create unique index ix_auth_username on authorities (username, authority);


insert into users (username, password) values ('dog', '1111');
insert into users (username, password) values ('cat', '1111');
insert into users (username, password) values ('tiger', '1111');

insert into authorities (username, authority) values ('dog', 'ROLE_USER');          -- 일반 유저
insert into authorities (username, authority) values ('cat', 'ROLE_MANAGER');       -- 중간 관리자
insert into authorities (username, authority) values ('tiger', 'ROLE_ADMIN');       -- 관리자
insert into authorities (username, authority) values ('tiger', 'ROLE_MANAGER');     -- 중간 관리자

commit;

select * from users;
select * from authorities;

create table member (
    memberid varchar2(50) primary key ,         -- 아이디(username)
    memberpw varchar2(100) not null,            -- 암호
    membername varchar2(50) not null,           -- 이름
    email varchar2(100) not null,               -- 이메일
    gender char(1) not null,                    -- 성별
    enabled char(1) default '1',                -- 활동 유무
    regdate date default sysdate not null       -- 회원가입 날짜
);

create table member_auth (
    memberid varchar2(50) not null,
    auth varchar2(50) not null,
    constraint fk_member_auth foreign key(memberid) references member(memberid)
);

commit;

select * from member;
delete from member where membername = '미야옹';


insert into member_auth values ('dog', 'ROLE_MEMBER');
insert into member_auth values ('cat', 'ROLE_MEMBER');
insert into member_auth values ('tiger', 'ROLE_MEMBER');
insert into member_auth values ('tiger', 'ROLE_ADMIN');

commit;