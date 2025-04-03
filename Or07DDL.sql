/*
파일명: Or07DDL.sql
DDL: Data Definition Language(데이터 정의어)
설명: 테이블, 뷰와 같은 객체를 생성 및 변경하는 쿼리문을 말한다.
*/
--system 계정으로 접속한 후 아래 명령을 실행
--개정 생성시 c##을 생략하고 만들 수 있도록 session을 변경
alter session set "_ORACLE_SCRIPT"=true;

--새로운 사용자 계정 생성
create user education identified by 1234;

--Role(역할)을 통해 접속 및 테이블생성 등의 권한을 부여
grant connect, resource, unlimited tablespace to education;


-------------------------------------------------------------------------
--education 계정으로 접속한 후 학습을 진행합니다.
--생성된 모든 계정에 논리적으로 존재하는 테이블
select * from dual;

/*현재접속한 계정에 생성된 테이블의 목록을 저장한 시스템 테이블
이와 같이 관리의 목적으로 생성된 테이블을 '데이터사전'이라고 표현한다.*/
select * from tab;

--테이블 생성

/*
형식] create table 테이블명(
    컬럼명1 자료형(크기),
    컬럼명2 자료형(크기)
    ...
    primary key(컬럼명) 등의 제약조건 추가
);
*/
create table tb_member(
    idx number(10), /*숫자형(정수)*/
    userid varchar2(30), /*문자형*/
    passwd varchar2(50),
    username varchar2(30),
    mileage number(7,2)  /*숫자형(실수)*/
);

--현재 접속된 계정에 생성에 테이블의 목록을 확인
select * from tab;

--테이블의 구조(스키마) 확인. 컬럼명, 자료형, 크기를 확인할 수 있다.
desc tb_member;


/*
기존 생성된 테이블에 새로운 컬럼 추가하기
    형식] alter table 테이블명 and 추가할 컬럼 자료형(크기) 제약조건;
*/
--tb_member 테이블에 email컬럼을 추가하시오
alter table tb_member add email varchar2(100);
desc tb_member;

/*
기존 생성된 테이블의 컬럼 수정(변경) 하기
형식] alter table 테이블명 modify 수정할컬럼명 자료형(크기)
*/
--emial컬럼의 사이즈를 200으로 확장하시오
alter table tb_member MODIFY email varchar2(200);

--이름이 저장되는 컬럼도 60으로 확장하시오
alter table tb_member MODIFY username varchar2(60);
desc tb_member;


/*
기존 생성된 테이블에서 컬럼 삭제하기
형식] alter table 테이블명 drop column 삭제할컬럼*/
--mileage 컬럼을 삭제하시오
alter table tb_member drop COLUMN mileage;
desc tb_member;


/*
퀴즈] 테이블 정의서로 작성한 employees테이블을 해당 education계정에그대로
    생성하시오. 단, 제약조건은 명시하지 않습니다. 
*/


create table employees(
    employee_id number(6),
    first_name varchar2(20),
    last_name varchar2(25),
    email varchar2(25),
    phone_number varchar2(20),
    hire_date date,
    job_id varchar(10),
    salary number(8,2),
    commission_pct number(2,2),
    manager_id number(6),
    department_id number(4)
);

desc employees;

/*
테이블 삭제하기
형식] drop table 삭제할 테이블명*/
--employees 테이블을 삭제하시오
select * from tab;
drop table employees;
desc employees;

--테이블을 삭제(drop)하면 휴지통(recylcebin)에 임시 보관된다.
show recyclebin;

--휴지통 비우기
purge RECYCLEBIN;

--휴지통에 보관된 테이블 복원하기
FLASHBACK table employees to before drop;


--tb_member 테이블에 새로운 레코드 입력하기
insert into tb_member values(1,'kosmo1', '1234','코스모155기',
    'kosmo155@naver.com');
select * from tb_member;


insert into tb_member values(2,'kosmo2', '1234','코스모156기',
    'kosmo155@gmail.com');
insert into tb_member values(3,'kosmo3', '1234','코스모157기',
    'kosmo155@nate.com');
--삽입된 레코드 확인
select * from tb_member;

--명시적 true조건이므로 모든 레코드를 대상으로 인출한다.
select * from tb_member where 1=1;

--명시적 false조건이므로 레코드를 인출하지 않는다.
select * from tb_member where 1=0;


--테이블 복사1: 테이블의 스키마(구조)만 복사
create table tb_member_copy1
as
select * from tb_member where 1=0;
--테이블의 구조만 복사되었으므로 레코드는 인출되지 않는다.
select * from tb_member_copy1;

--테이블 복사2: 테이블의 스키마(구조)와 레코드까지 모두 복사
create table tb_member_copy2
as
select * from tb_member where 1=1;
--true의 조건으로 레코드까지 복사했으므로 인출된다.
select * from tb_member_copy2;








