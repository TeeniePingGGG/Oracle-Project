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






























