/*
파일명:Or13DCL.sql
DCL: Data Control Language(데이터 제어어)
사용자 권한 관리
설명: 새로운 사용자 계정을 생성하고 시스템 권한 부여 및 회수하는
    방법을 학습
*/

/*
사용자 계정 생성 및 권한설정
:해당 작업은 DBA권한이 있는 최고관리자(system,sys)으로 접속한 후 
실행해야한다.
새로운 사용자 계정이 생성된 후 접속 및 쿼리실행 테스트는 CMD(명령프롬프트)
에서 진행한다*/

/*
1] 사용자 계정 생성 및 암호설정
형식] create user 아이디 identified by 패스워드;
*/
--c## 접두어를 제거한 후 사용자를 생성하기 위한 세션 변경
alter session set "_ORACLE_SCRIPT"=true;
--새로운 사용자 계정 생성
create user test_user1 identified by 1234;


/*
계정 생성 직후 CMD에서 sqlplus 명령으로 접속을 시도해보면
create session 권한이 없어 접속할 수 없다는 에러가 발생한다.

-------------------------------------------------------------------------------
CMD>>>
    sqlplus
    test_user1 /1234 입력해서 접속시도
*/

/*
2] 생성된 사용자 계정에 권한 혹은 역할(Role) 부여
형식] grant 시스템권한1, 시스템권한2 혹은 역할
        to 사용자계정
            [with grant 옵션]
*/
--접속 권한 부여
grant create session to test_user1;

/*
create session 권한 부여 후 접속에는 성공했지만, 테이블은
생성할 수 없다.
---------------------------------------------------------------------------
CMD??
    sqlplus로 접속 성공 후
    create table tb_test(
        idx number(5) primary key);
*/
--테이블 생성 권한 부여
grant create table to test_user1;

/*
create table 권한 부여 후 테이블 생성 및 desc 명령으로 생성된
테이블의 스키마를 확인할 수 있다.
*/

/*
3] 암호변경
형식] alter user 사용자계정 identified by 변경할 암호;
*/
alter user test_user1 identified by 4321;

/*
exit 혹은 quit명령으로 접속을 해제한 후 다시 접속하면 기존
암호로는 접속할 수 없다. 변경한 암호로 접속해야한다.
*/

/*
4]Role(롤, 역할)을 통해 여러가지 권한을 동시에 부여하기
: 여러 사용자가 다양한 권한을 효과적으로 관리할 수 있도록 관련된
권한끼리 묶어놓은것을 말한다
우리는 실습을 위해 새롭게 생성한 계정 connect, resource 롤을 주로 
부여한다.
*/
--두번째 계정을 생성한 후 Role를 통해 권한을 부여한다
create user test_user2 identified by 1234;
/*아래 2개의 Role은 오라클에서 기본적으로 제공된다. 접속 및 테이블 생성
등의 대부분의 기본작업을 할 수 있는 권한이 포함되어있다.*/
grant connect, resource to test_user2;

/*4-1]Role 생성하기: 사용자가 원하는 권한을 묶어 새로운 롤 생성*/
create role my_role;

/*
4-2]Role에 권한 부여하기*/
--새롭게 생성한 롤에 3가지 권한을 부여한다.
grant create session, create table, create view to my_role;

--세번쨰 계정 생성
create user test_user3 identified by 1234;

--우리가 직접 생성한 롤을 통해 권한을 부여한다.
grant my_role to test_user3;

/*
my_role 을 통해 권한을 부여했으므로 접속 및 테이블 생성이
정상적으로 실행된다.
*/

/*
4-3]Role 삭제하기
*/
drop role my_role;
/*
test_user2은 my_role을 통해 권한을 부여받았으므로 해당 롤은
삭제하면 모든 권한이 회수(Rovoke)된다.
즉, 롤 삭제 후에는 접속 및 기타작업을 할 수 없다.
*/

/*
5]권한회수(제거)
    형식] revoke 권한 혹은 롤 from 사용자계정;
*/
]
revoke create session from test_user1;
/*
접속 권한 회수 후 접속을 시도할때 비밀번호가 틀리면 '부적합' 에러가
발생되고, 비밀번호가 일치하면 create session권한이 없다고 출력된다.*/

/*
6]사용자 계정 삭제
형식] drop user 사용자계정 [cascade];
cascade를 명시하면 사용자계정과 관련된 모든 데이터베이스 스키마가
데이터사전으로부터 삭제되고 모든 스키마 객체도 물리적으로 삭제된다.
*/
--현재 생성된 사용자 계정을 확인할 수 있는 데이터사전
select username from dba_users;
select * from dba_users where username=upper('test_user1');

--계정을 삭제하면서 모든 물리적인 스키마까지 함께 삭제한다.
drop user test_user1 cascade;








































