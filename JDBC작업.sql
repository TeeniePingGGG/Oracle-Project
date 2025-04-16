--Java에서 JDBC 연동하기
--education 계정에서 실습합니다.

--member테이블 생성
 CREATE TABLE member
(
    /*아이디, 비번, 이름은 문자타입으로 정의. not null로 
    빈값을 허용하지 않는 컬럼으로 정의*/
	id VARCHAR2(30) NOT NULL,
	pass VARCHAR2(40) NOT NULL,
	name VARCHAR2(50) NOT NULL,
    /* 날짜타입으로 선언. null을 허용하는 컬럼으로 정의.
    입력값이 없는 경우 현재 시각을 디폴트로 입력한다.*/
	regidate DATE DEFAULT SYSDATE,
    /*아웃라인 방식으로 아이디 컬럼을 PK지정*/
	PRIMARY KEY (id)
);
--테이블에 더미데이터(테스트용 데이터) 추가
insert into member (id, pass, name) values ('test', '1234', '테스트');

select * from member;
commit;
/*
더미데이터 입력 후 commit을 실행하지 않으면 오라클 외부 프로그램에서는
새롭게 입력한 데이터를 확인할 수 없다, 입력된 레코드를 실제 테이블에
적용하기 위해 반드시 commit을 실행해야한다.
Java와 같은 외부프로그램을 통해 입력하는 데이터는 자동으로 commit이 
되므로 별도의 처리를 하지 않아도 된다.
*/

--레코드 수정하기
select * from member;
update member set pass='99xx', name='나수정'
    where id='test1';

--더미데이터 입력
insert into member (id, pass, name) values ('commit1', '1111', '커밋');

--커밋을 실행하지 않으면 Java에서 JDBC작업을 할 수 없다.
commit;

--레코드 삭제
delete from member where id='22';
commit;

--레코드 검색
select * from member where name like '%유%';
select * from member where name like '%스%';


select * from member;


/*
퀴즈] 위에서 생성한 테이블에 외래키와 시퀀스를 설정하시오.
1. 외래키명 : board_mem_fk
board 테이블의 id 컬럼이 member 테이블의 id 컬럼을 참조하도록 외래키를 생성
2. 시퀀스명 : seq_board_num
board 테이블에 데이터를 입력시 num 컬럼이 자동증가 할 수 있도록 시퀀스를 생성
*/

--게시판 테이블 생성
CREATE TABLE board
(
    num number primary key, /*일련번호(PK)*/
    title varchar2(200) not null, /*제목*/
    content varchar2(2000) not null, /*내용*/
    id varchar2(30) not null, /*회원제이므로 회원아이디 컬럼 필요*/
    postdate date default sysdate not null, /*게시물 작성일*/
    visitcount number default 0 not null /*게시물 조회수*/
);

--외래키 설정
/*
외래키명 : board_mem_fk
board 테이블의 id 컬럼이 member 테이블의 id 컬럼을 참조하도록 외래키를 생성
*/
alter table board /*외래키는 자식테이블에서 설정함*/
    add constraint board_mem_fk  /*제약명 지정*/ 
        foreign key(id)     /*자식테이블의 외래키를 지정할 컬럼*/
            references member(id);/*부모테이블에 참조할 컬럼*/

--자식테이블인 board에 더미데이터 추가
/*
아이디 aaaa는 부모테이블인 member에 존재하지 않으므로 insert문
실행시 에러가 발생한다.*/
insert into board (num,title,content,id, postdate,visitcount)
    values(1,'제목','내용','aaaa',sysdate,0 );


/*
시퀀스명 : seq_board_num
board 테이블에 데이터를 입력시 num 컬럼이 자동증가 할 수 있도록 시퀀스를 생성
*/
create sequence seq_board_num
/*증가치, 시작갑스 최솟값을 모두 1로 지정*/
    increment by 1
    start with 1
    minvalue 1
    /*최대값, 사이클, 캐시메모리 사용을 모두 NO지정*/
    nomaxvalue
    nocycle
    nocache;

/*
2개의 테이블이 참조관게에 있다면 데이터 입력시 부모테이블부터 입력해야
한다. 만약 자식테이블에 먼저 입력하면 '부모키가 없다'는 에러가 발생한다.*/
insert into member (id, pass, name) values ('kosmo', '1234', '코스모');
insert into member (id, pass, name) values ('musthave', '1234', '머스트해브');
--자식테이블인 board에 레코드 입력
insert into board (num,title,content,id, postdate,visitcount)
    values(seq_board_num.nextval,'제목1','내용1','kosmo',sysdate,0 );

insert into board (num,title,content,id, postdate,visitcount)
    values(seq_board_num.nextval,'제목2','내용2','musthave',sysdate,0 );

--레코드 확인
select * from member;
select * from board;

commit;

/**********************************************************************/
--JDBC > CallableStatement 인터페이스 사용하기

--eduction계정에서 실습합니다.

--예제1-1] 함수 : fillAsterik()

--substr(문자열 혹은 컬럼, 시작인덱스, 길이): 시작인덱스부터 길이만큼
--  잘라낸다.
select substr('honglildong',1,1) from dual;

--rpad(문자열 혹은 컬럼, 길이, 채울문자): 문자열의 남은 길이를 문자로 채움
select rpad('h',10,'*') from dual;
/*위 2개의 쿼리를 병합해서 문자열(아이디)의 첫글자를 제외한 나머지
부분을 *로 마스킹 처리하는 쿼리문을 생성한다.*/
select rpad(substr('honglildong',1,1),length('honglildong'),'*')
    from dual;
    
--함수생성    
create or replace function fillAsterik(
    idStr VARCHAR2 /*인파라미터는 문자형으로 설정*/
)
return VARCHAR2 /*반환타입도 문자형으로 설정*/
is
    retStr VARCHAR2(50); /*마스킹 후 반환할 문자열을 저장할 변수 선언*/
begin
    /*인파라미터로 전달받은 아이디를 마스킹 처리 후 반환*/
    retStr:=rpad(substr(idStr,1,1),length(idStr),'*');
    return retStr;
end;
/

select fillAsterik('honglildong') from dual;
--예제1-1] 함수 : fillAsterik()
select substr('honglildong',1,1) from dual;
select rpad('h',10,'*') from dual;
select rpad(substr('honglildong',1,1),length('honglildong'),'*')
    from dual;
    
create or replace function fillAsterik(
    idStr VARCHAR2
)
return VARCHAR2
is
    retStr VARCHAR2(50);
begin
    retStr:=rpad(substr(idStr,1,1),length(idStr),'*');
    return retStr;
end;
/
--우리가 전달한 문자열이 마스킹 처리 되는지 확인
select fillAsterik('honglildong') from dual;
select fillAsterik('oracle21c') from dual;
select fillAsterik('hello') from dual;


--생성한 함수는 즉시 테이블에 적용할 수 있다.
select * from member;
--회원테이블의 id컬럼을 마스킹 처리한다
select fillAsterik(id) from member;


/*
시나리오] member 테이블에 새로운 회원정보를 입력하는 프로시저를 생성하시오
    파라미터 : In => 아이디, 패스워드, 이름
                    Out => returnVal(성공:1, 실패:0)
*/
create or replace PROCEDURE MyMemberInsert(
    /*Java에서 입력한 값을 받을 인파라미터 정의*/
    p_id in varchar2,
    p_pass in varchar2,
    p_name in varchar2,
    /*입력성공여부를 반환할 숫자형식의 아웃파라미터*/
    returnVal out NUMBER
)
is --변수 선언 없음
begin 
    --인파라미터를 통해 회원정보를 입력하는 insert 쿼리문 작성
    insert into member(id,pass,name)
        values(p_id, p_pass, p_name);
     --입력이 정상적으로 처리되면 true를 반환   
    if sql%found then
        --입력에 성공한 행의 갯수를 얻어와서 아웃파라미터에 저장
        returnVal :=sql%rowcount;
        --행의 변화가 생기므로 반드시 커밋 해야한다.
        commit;
    else
        --실패한 경우에는 0을 반환
        returnVal:=0;
    end if;
    --프로시저는 별도의 return없이 아웃파라미터에 값을 할당하기만 하면된다.
end;
/

set serveroutput on;

var i_result varchar2(10);
execute MyMemberInsert('pro01','1111','프로시저1',:i_result);
execute MyMemberInsert('pro04','2222','프로시저2',:i_result);
--결과확인
print i_result;
--레코드가 입력되었는지 테이블에서 직접 확인
select * from member;



--레코드 확인하기
select * from trigger_dept_original;
/*오리지날 테이블에서 5개의 레코드가 수정되었지만 테이블 단위 트리거이므로
백업테이블에는 1개의 레코드만 삽입된다.*/
select * from trigger_dept_backup;


/*
시나리오] member테이블에서 레코드를 삭제하는 프로시저를 생성하시오
    파라미터 : In => member_id(아이디)
                    Out => returnVal(SUCCESS/FAIL 반환)   
*/
create or replace PROCEDURE MyMemberDelete(
    /*인파라미터: 삭제할 아이디*/
    member_id in varchar2,
    /*아웃파라미터: 삭제 결과*/
    returnVal out varchar2
)
is
begin
    --인파라미터로 전달된 아이디를 삭제하는 delete 쿼리문 작성
    delete from member where id=member_id;
    
    if SQL%Found then
        --회원 레코드가 정상적으로 삭제되면....
        returnVal:='SUCCESS';
        --커밋한다.
        commit;
    else
        --삭제할 아이디가 존재하지 않는다면 FAIL을 반환
        returnVal:='FAIL';
    end if;
end;
/

set serveroutput on;

--프로시저 테스트를 위한 바인드 변수 생성
var delete_var varchar2(10);
--존재하지 않는 아이디로 테스트
execute MyMemberDelete('ㅅㄷ',:delete_var);
--존재하는 아이디로 테스트
execute MyMemberDelete('pro01',:delete_var);

print delete_var;

select * from member;



/*
시나리오] 아이디와 패스워드를 매개변수로 전달받아서 회원인지 여부를 판단하는 프로시저를 작성하시오. 
    매개변수 : 
        In -> user_id, user_pass
        Out -> returnVal
    반환값 : 
        0 -> 회원인증실패(둘다틀림)
        1 -> 아이디는 일치하나 패스워드가 틀린경우
        2 -> 아이디/패스워드 모두 일치하여 회원인증 성공
    프로시저명 : MyMemberAuth
*/

create or replace PROCEDURE MyMemberAuth(
    /*인파라미터: 아이디, 비번*/
    user_id in varchar2,
    user_pass in varchar2,
    /*아웃파라미터: 0~2사이의 숫자*/
    returnVal out number
)
is
    --count(*)를 통해 반환되는 값 저장
    member_count number(1):=0;
    --조회할 회원의 패스워드를 저장
    member_pw varchar2(50);
begin
    --쿼리1: 아이디가 존재하는지 확인
    select count(*) 
        into member_count
    from member
        where id=user_id;
    
    --회원아이디가 존재하는 경우라면..........
    if member_count=1 then
        --쿼리2: 패스워드 확인을 위한 쿼리문 실행
        select pass 
            into member_pw
        from member
            where id=user_id;
     --인파라미터로 전달된 비번과 DB에서 가져온 비번 비교       
    if member_pw=user_pass then
        --둘다 일치하는 경우 2로 설정
        returnVal:=2;
    else
        --아이디만 일치하는 경우 1로 설정(비번틀림)
        returnVal:=1;
    end if;
    else
        --회원정보가 틀린 경우 0으로 설정
        returnVal:=0;
    end if;
end;
/

--바인드 변수 생성
variable member_auth number;

-- 둘다 일치하는 경우(인증 성공)
execute MyMemberAuth('pro04','2222',:member_auth);
print member_auth;

--아이디만 있는 경우
execute MyMemberAuth('pro04','ffff',:member_auth);
print member_auth;
--회원정보가 없는 경우
execute MyMemberAuth('코딱지','2222',:member_auth);
print member_auth;




--------------------개인프로젝트------------------------------------------------
/*
테이블 생성
테이블명 : banking
컬럼 : 일련번호, 계좌번호, 이름, 잔액, 이자율
primary key, not null과 같은 제약조건 추가 
시퀀스 생성
시퀀스명 : seq_banking_idx
*/


create table banking(
    num number primary key,
    acnum varchar2(50) not null,
    name varchar2(30) not null,
    money number ,
    basicInterestRate number
);
select * from banking;

create sequence seq_banking_idx

    increment by 1
    start with 1
    minvalue 1
    /*최대값, 사이클, 캐시메모리 사용을 모두 NO지정*/
    nomaxvalue
    nocycle
    nocache;


-- 프로시저 생성
CREATE OR REPLACE PROCEDURE DeleteAccount(
    acnum_delete IN VARCHAR2,
    returnVal OUT VARCHAR2
)
IS
BEGIN
    DELETE FROM banking WHERE acnum = acnum_delete;

    IF SQL%ROWCOUNT > 0 THEN
        returnVal := 'SUCCESS';
        COMMIT;
    ELSE
        returnVal := 'FAIL';
    END IF;
END;
/


/*
시나리오] member테이블에서 레코드를 삭제하는 프로시저를 생성하시오
    파라미터 : In => member_id(아이디)
                    Out => returnVal(SUCCESS/FAIL 반환)   
*/
create or replace PROCEDURE MyMemberDelete(
    /*인파라미터: 삭제할 아이디*/
    member_id in varchar2,
    /*아웃파라미터: 삭제 결과*/
    returnVal out varchar2
)
is
begin
    --인파라미터로 전달된 아이디를 삭제하는 delete 쿼리문 작성
    delete from member where id=member_id;
    
    if SQL%Found then
        --회원 레코드가 정상적으로 삭제되면....
        returnVal:='SUCCESS';
        --커밋한다.
        commit;
    else
        --삭제할 아이디가 존재하지 않는다면 FAIL을 반환
        returnVal:='FAIL';
    end if;
end;
/

set serveroutput on;

--프로시저 테스트를 위한 바인드 변수 생성
var delete_var varchar2(10);
--존재하지 않는 아이디로 테스트
execute MyMemberDelete('ㅅㄷ',:delete_var);
--존재하는 아이디로 테스트
execute MyMemberDelete('pro01',:delete_var);

print delete_var;

select * from member;











