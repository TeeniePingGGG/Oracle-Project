/*
파일명: Or08DML.sql
DML:  Data Manipulation Language(데이터 조작어)
설명: 레코드를 조작할떄 사용하는 쿼리문. 앞에서 학습했던 select문을
    비롯하여 update(레코드수정), delete(삭제), insert(입력) 문이
    있다.
*/
--eduction계정에서 학습합니다.

--새로운 테이블 생성
create table tb_sample(
    no number(10),
    name varchar2(20),
    loc varchar2(15),
    manager varchar2(30)
);
desc tb_sample;

/*
레코드 입력하기:insert
    레코드 입력을 위한 쿼리문으로 문자형은 반드시 '로 감싸야하고
    숫자형은 '없이 기술한다. 만약 숫자형을 감싸게 되면 실행시 자동으로
    변환되어 입력된다.
*/
--레코드 입력1: 컬럼을 지정한 후 insert
insert into tb_sample(no,name,loc,manager)
    values (10,'기획실','서울','유비');
insert into tb_sample(no,name,loc,manager)
    values (20,'전산팀','수원','관우');
    
select * from tb_sample;
    
--레코드 입력2: 컬럼 지정없이 전체컬럼을 대상으로 insert
insert into tb_sample values (30,'영업팀','대구','장비');
insert into tb_sample values (40,'인사팀','부산','조자룡');
select * from tb_sample;

/*
컬럼을 지정해서 insert하는 경우 데이터를 삽입하지 않을 컬럼을 지정할 수 있다.
아래의 경우 name컬럼은 null값이 삽입된다.*/

insert into tb_sample(no,loc,manager) values (50,'제주','동탁');
select * from tb_sample;

/*
지금까지의 작업을 그대로 유지하겠다는 명령으로 커밋을 수행하지 않으면
오라클 외부에서는 변경된 레코드를 확인할 수 없다
여기서 말하는 외부랑 Java/Jsp와 같은 oracle이외에 프로그램을 말한다.*/
commit;

--커밋 이후 새로운 레코드르 삽입하면 임시테이블에 저장된다.
insert into tb_sample(no,loc,manager) values (60,'태국','손오공');
--select명령으로 확인할 수 있지만 실제 테이블에는 반영되지 않은 상태이다
select * from tb_sample;
--롤백 명령으로 마지막 커밋 상태로 되돌릴 수 있다
rollback;
--마지막 커밋 이후에 삽입된 '손오공'은 제거된다.
select * from tb_sample;


/*
레코드 수정하기:update
형식] update 테이블명 set 컬럼=값 where 조건;
※조건이 없는 경우 모든 레코드가 한꺼번에 수정된다.
※테이블명 앞에 from이 들어가지 않는다.
*/
--번호가 40인 레코드의 지역을 '미국'으로 수정하시오
update tb_sample set loc='미국' where no=40;
select * from tb_sample;

--지역이 서울인 레코드의 메니저명을 '제갈공명'으로 변경하시오
update tb_sample set manager='제갈공명' where loc='서울';
select * from tb_sample;

--모든 레코드를 대상으로 지역을 '가디'로 변경하시오.
update tb_sample set loc='가디';
--전체 레코드를 대상으로 하는 경우 where절을 생략하면 된다.
select * from tb_sample;

/*
레코드 삭제하기: delete
형식] delete from 테이블명 where 조건;
레코드를 삭제하므로 delete뒤에 컬럼을 명시하지 않는다.
*/
--번호 10인 레코드를 삭제하시오
delete from tb_sample where no=10;
select * from tb_sample;

--레코드를 전체를 삭제하시오
delete from tb_sample;
select * from tb_sample;

--마지막 커밋했던 지점으로 되돌린다.
rollback;
select * from tb_sample;


/*
DDL문: 테이블을 생성 및 조작하는 쿼리문
    (Data Definition Language: 데이터 정의어)
    테이블 생성: crate table 테이블명
    테이블 수정  
        컬럼추가: alter table 테이블명 add 컬럼명
        컬럼수정: alter table 테이블명 modify 컬럼명
        컬럼삭제: alter table 테이블명 drop column 컬럼명
    테이블 삭제: drop table 테이블명
    
DML문: 레코드를 입력 및 조작하는 쿼리문
    (Data Manipulation Language: 데이터 조작어)
    레코드 입력: insert into 테이블명(컬럼명) values(값)
    레코드 수정: update 테이블명 set 컬럼=값 where 조건
    레코드 삭제: delete from 테이블명 where 조건
*/



















































