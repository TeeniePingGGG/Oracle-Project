/*
파일명:Or12sequence&Index.sql
시퀀스 & 인덱스
설명: 테이블의 기본키 필드에 순차적인 일련번호를 부여하는 시퀀스와
    검색속도를 향상시킬수 있는 인덱스
*/
--education 계정에서 학습-------------------------------------------------------

/*
시퀀스(Sequence)
-테이블의 컬럼에 중복되지 않는 순차적인 일련번호를 부여한다.
-시퀀스는 테이블 생성 후 병도로 만들어야한다. 따라서 시퀀스는 
    테이블과 독립적으로 생성되고 저장된다
    
형식] create sequence 시퀀스명
        Increment by N -> 증가치
        Start with N   -> 시작값
        Minvalue N     -> 시퀀스 최소값
        Maxvalue N     -> 시퀀스 최대값
        Cycle 혹은 NoCycle -> 최대값에 도달한 경우 처음부터 다시 시작할지 여부 결정
        Cache 혹은 NoCache -> cache 메모리에 오라클 서보가 시퀀스 값을
                                할당할지 여부를 지정
*/
create table tb_goods(
    idx number(1) primary key,
    g_name varchar2(30)
);
--1,2는 정상입력
insert into tb_goods values(1,'허니버터칩');
insert into tb_goods values(2,'포켓몬빵');
--세번째 데이터는 일련번호가 중복되어 에러발생
insert into tb_goods values(2,'크보빵');

select * from tb_goods;

--시퀀스 생성
create sequence seq_serial_num
    increment by 1 /*증가치: 1*/
    start with 10 /*초깃값(시작값): 10*/
    minvalue 9 /*최솟값: 9*/
    maxvalue 20 /*최대값: 20*/
    cycle /*최대값 도달시 최소값부터 재시작 여부: Yes*/
    nocache; /*캐시메모리 사용 여부:No*/

--시퀀스 확인을 위한 데이터사전    
select * from user_sequences;


/*
시퀀스 생성 후 최초 실행시에는 currval을 실행할 수 없어 에러가 발생됨
nextval을 먼저 실행해서 시퀀스를 얻어온 후 실행해야한다*/
select seq_serial_num.currval from dual;
/*
다음 입력할 시퀀스를 반환한다. 실행할때마다 설정한 증가치만큼 증가된
값이 반환된다.*/
select seq_serial_num.nextval from dual;

/*시퀀스의 nextval을 사용하면 계속 새로운 값을 반환하므로 아래와 같이
insert문에 사용할 수 잇다. 또한 같은 쿼리문을 여러번 실행하더라도
문제없이 입력된다.*/
insert into tb_goods values(seq_serial_num.nextval,'크보빵');

select * from tb_goods;
/*단, 시퀀스의 cycle옵션에 의해 최대값에 도달하면 다시 처음부터
시퀀스가 생성되므로 무결성제약조건에 위배되어 에러가 발생된다
즉 pk컬럼에 사용할 시퀀스는 cycle옵션은 사용하지 않아야한다.*/



/*
시퀀스 수정: 테이블과 동일하게 alter문을 사용한다
    단, start with는 수정할 수 없다*/
alter sequence seq_serial_num
    increment by 1
    minvalue 9 /*최소값은 기존에 설정된 값보다 크면 에러 발생*/
    nomaxvalue /*최대값 사용하지 않음. 즉 표현할 수 있는 최대범위 사용*/
    nocycle /*사이클 사용하지 않음*/
    nocache; /*캐시메모리 사용하지 않음*/

--시퀀스 삭제
drop sequence seq_serial_num;
select * from user_sequences;


--일반적인 시퀀스 생성은 아래와 같이 하면 된다.
/*PK로 지정된 컬럼에 일련번호를 입력하는 용도로 주로 사용되므로
최대갑스 싸이클, 캐시는 사용하지 않는것을 권장한다.*/
create sequence goods_idx_seq
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;


/*
인덱스(Index)
-행의 검색속도를 향상시킬 수 있는 개체
-인덱스는 명시적(create index)과 자동적(primary key, unique)으로
생성할 수 있다. 
-컬럼에 대한 인덱스가 없으면 테이블 전체를 검색한다. 
-즉 인덱스는 쿼리의 성능을 향상시키는 것이 그 목적이다. 
-인덱스는 아래와 같은 경우에 설정한다. 
    1.where조건이나 join조건에 자주 사용하는 컬럼
    2.광범위한 값을 포함하는 컬럼
    3.많은 null값을 포함하는 컬럼
*/
--인덱스 생성하기 
create index tb_goods_name_idx on tb_goods (g_name);
/* 데이터 사전에서 확인. 결과를 보면 PK 혹은 Unique로 지정된 컬럼은
자동으로 인덱스가 생성되어 있는것을 볼 수 있다. */
select * from user_ind_columns;
--인덱스 삭제 
drop index tb_goods_name_idx;
/*
    인덱스는 수정이 불가능하다. 필요하다면 삭제 후 다시 생성해야한다. 
*/


























































