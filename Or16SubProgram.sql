/*
파일명: Or16SubProgram.sql
서브프로그램
설명: 저장프로시저, 함수 그리고 자동으로 실행되는 프로시저인
    트리거를 학습한다.*/
    
    
 /*
 서브프로그램(Sub program)
 -PL/SQL에서는 프로시저와 함수라는 두가지 유형의 서브프로그램이 있다
 -select를 포함해서 모든 DML문을 이용하여 프로그래밍적인 요소를 통해
    사용가능하가
-프로시저: 외부프로그램에서 호출하기 위해 정의한다. 따라서 java,jsp
    등에서 간단한 호출로 복잡한 쿼리를 실행할 수 있다.
-함수: 쿼리문의 일부분으로 사용하기 위해 정의한다. 즉 외부 프로그램에서 
    호출하는 경우는 거의 없다
-트리거: 프로시저의 일종으로 특정 테이블에 레코드의 변화가 있을경우
    자동으로 실행된다. 즉 직접 호출하지 않는다.*/   
/*
1.저장 프로시저(Stored Procedure)
-프로시저는 return문이 없는 대신 out파라미터를 통해 값을 반환한다.
-보안성을 높일수 있고, 네트워크의 부하를 줄일 수 있다
형식] create [or replace] procedure 프로시저명
    [(매개변수 in자료형, 매개변수 out 자료형])
    is 변수선언
    begin
        실행문장;
    end;
※매개변수 설정시 자료형만 명시하고, 크기는 명시하지 않는다
*/    

--시나리오] 100번 사원의 급여를 select하여 출력하는 저장프로시저를 생성하시오.

--프로시저는 생성시 or replace를 추가하는것이 좋다.
--매개변수는 필요없는 경우 생략할 수 있다.
create or replace PROCEDURE pcd_emp_salary 
is
    /*PL/SQL에서는 declare절에 변수를 선언하지만, 프로시저에서는
    is절에 선언한다. 만약 선언할 변수가 없다면 내용을 생략할 수 있다.*/
    v_salary employees.salary%type;
begin    
    --100번 사원의 급여를 into를 이용해서 변수에 저장
    select salary into v_salary
    --결과를 내부에서 출력
    from employees
    where employee_id=100;
    
    dbms_output.put_line('사원번호 100의 급여는:'||v_salary||'입니다' );
end;
/
--실행하면 데이터 사전에 저장만 되고 실행결과가 출력되진 않는다.
/*데이터 사전에서 확인할때는 '대문자'로 저장되므로 아래와 같이 upper함수를
사용해야한다.*/
select * from user_source where name like upper('%pcd_emp_salary%');

--만약 첫 실행이라면 최초 한번 실행해준다.
set serveroutput on;
--프로시저의 호출은 호스트환경에서 execute 명령을 이용한다.
execute pcd_emp_salary;



--예제2] IN파라미터 사용하여 프로시저 생성
/*
시나리오] 사원의 이름을 매개변수로 받아서 사원테이블에서 레코드를 조회한후
해당사원의 급여를 출력하는 프로시저를 생성 후 실행하시오.
해당 문제는 in파라미터를 받은후 처리한다.
사원이름(first_name) : Bruce, Neena
*/

--프로시저 생성시 in파라미터를 설정. first_name 컬럼을 참조하는 형식으로 선언
create procedure pcd_in_param_salary
    (param_name in employees.first_name%type)
is
    valSalary number(10); /*변수선언*/
    
begin
    /*in파라미터로 받은 사원명을 쿼리의 조건으로 사용하여 급여를
    인출한 후 변수에 할당*/
    select salary into valSalary
    from employees
    where first_name=param_name;
    
    --결과를 출력
    dbms_output.put_line(param_name||'의 급여는'|| valSalary||'입니다');
end;
/
--데이터 사전에서 확인하기(대문자로 저장되므로 변환 필요)
select * from user_source where name like upper('%pcd_in_param_salary%');

--execute명령으로 프로시저 실행
execute pcd_in_param_salary('Bruce');
execute pcd_in_param_salary('Neena');



/*
예제3] OUT파라미터 사용하여 프로시저 생성

시나리오] 위 문제와 동일하게 사원명을 매개변수로 전달받아서 급여를 조회하는
프로시저를 생성하시오. 단, 급여는 out파라미터를 사용하여 반환후 출력하시오
*/

/*
두가지 형식의 파라미터를 정의. 일반변수, 참조변수를 사용해서 선언함
파라미터는 용도에 따라 in,out을 명시한다. 단 크기는 별더러 명시하지
않는다.*/
create or replace procedure pcd_out_param_salary
    (
        param_name in varchar2,
        param_salary out employees.salary%type
    )
is
    /*select한 결과를 out파라미터에 저장할 것이므로 별도의 변수가
    필요하지 않아 is절을 비워둔다.*/
begin
    /*in파라미터는 where절의 조건으로 사용하고,select한 결과는
    into절에서 out 파라미터에 저장한다.*/
    select salary 
        into param_salary
    from employees
    where first_name=param_name;
    /*프로시저에서는 별도로 return을 명시하지 않는다. 실행이 종료되면
    out파라미터에 할당된 값이 자동으로 반환된다.*/
end;
/

--호스트 환경에서 바인드 변수를 선언한다.(variable도 사용가능)
var v_salary varchar2(30);

/*프로시저 호출시 각각의 파라미터를 사용한다. 특히 바인드변수는 :을
붙여야한다. Out파라미터인 param_salary에 저장된 값이 v_salary로 전달된다.*/
execute pcd_out_param_salary('Matthew',:v_salary);

--프로시저 실행 후 out파라미터를 통해 전달된 값을 출력한다.
print v_salary;


/*
프로시저에서 update문 실습을 위해 employees테이블을 레코드까지 모두
복사한 후 진행합니다.
복사할 테이블명: zcopy_employees
*/
create table zcopy_employees
as
select * from employees
where 1=1;

--테이블 확인
desc zcopy_employees;

--복사된 레코드 확인
select * from zcopy_employees;


/*
시나리오] 사원번호와 급여를 매개변수로 전달받아 해당사원의 급여를 수정하고, 
실제 수정된 행의 갯수를 반환받아서 출력하는 프로시저를 작성하시오.*/

/*
in파라미터는 사원번호, 급여를 전달받는다. out파라미터는 update가
적용된 행의 갯수를 반환하는 용도로 선언*/

create or replace procedure pcd_update_salary
    (
        p_empid in number,
        p_salary in number,
        rCount out number
    )
is --추가적인 변수선언이 필요없으므로 생략
begin
    --실제 업데이트를 처리하는 쿼리문으로  in파라미터릏 통해 값 설정
    update zcopy_employees
        set salary = p_salary
        where employee_id=p_empid;
    
    /*
    SQL%NotFound: 쿼리실행 후 적용된 행이 없을 경우 true를 반환한다.
        found는 반대의 경우를 반환함
    SQL%RowCount: 쿼리 실행 후 실제 적용된 행의 갯수를 반환한다.    */    
    if SQL%notfound then
        dbms_output.put_line(p_empid||'은(는) 없는사원임다');
    else
        dbms_output.put_line(SQL%rowcount||'명의 자료가 수정되씸');
        
        --실제 적용된 행의 갯수를 반환하여 Out파라미터에 할당
        rCount := sql%rowcount;
    end if;
    
    /*
    행의 변화가 있는 insert, update, delete쿼리를 실행하는 경우 반드시
    commit해야 실제 테이블에 적용되어 Oracle외부에서 확인할 수 있다.*/
    commit;
end;
/

--프로시저 실행을 위해 바인드 변수 생성
variable r_count number;

--100번 사원의 이름과 급여 확인
select first_name, salary from zcopy_employees where employee_id=100;

--프로시저 실행. 급여를 30000으로 업데이트. 바인드변수에는 :을 붙여야한다
execute pcd_update_salary(100,30000,:r_count);

--update가 적용된 행의 갯수 확인
print r_count;

--업데이트된 내용을 확인
select first_name, salary from zcopy_employees where employee_id=100;


/*
시나리오] 2개의 정수를 전달받아서 두 정수사이의 모든수를 더해서 
결과를 반환하는 함수를 정의하시오.
실행예) 2, 7 -> 2+3+4+5+6+7 = ??
*/
--함수는 in파라미터만 있으므로 in은 주로 생략한다.
create or REPLACE function calSumBetween(
    num1 number,
    num2 number
)
return  --함수는 반환값이 필수이므로 반환타입을 명시해야한다.
    number
is
    --변수선언(선택사항: 필요없는 경우 생략가능)
    sumNum number;
begin
    sumNum:=0;
    
    --for루프문으로 숫자 사이의 합을 계산한 후 반환
    for i in num1..num2 loop
        sumNum:=sumNum+i;
    end loop;
    
    --결과를 반환
    return sumNum;
end;
/
--실행방법1: 쿼리문의 일부로 사용(권장)
select calSumBetween(1,10) from dual;

--실행방법2: 바인드변수를 통한 실행명령으로 주로 디버깅용으로 사용
var hapText varchar2(100);
execute :hapText :=calSumBetween(1,100);
print haptext;

/*
퀴즈] 주민번호를 전달받아서 성별을 판단하는 함수를 정의하시오.
999999-1000000 -> '남자' 반환
999999-2000000 -> '여자' 반환
단, 2000년 이후 출생자는 3이 남자, 4가 여자임.
함수명 : findGender()
*/

create or REPLACE function findGender(
    juminNum varchar2
)
return  
    varchar2
is
  gender varchar2(50);
begin
  gender:='';
  
    if substr(juminNum,8,1)=3 then 
          gender:='남';
    elsif substr(juminNum,8,1)=1 then 
        gender:='남';
    elsif substr(juminNum,8,1)=2 then
        gender:='여';
    elsif substr(juminNum,8,1)=4 then
         gender:='여';
    else
        gender:='너 누구여?';
    end if;    

    return gender;
end;
/
--실행확인
select findGender('999999-7000000') from dual; 
select findGender('999999-4000000') from dual;

--슨생님 풀이----------------------------------------------------

--in파라미터로 주민번호를 받아야하므로 문자타입으로 선언
CREATE OR REPLACE FUNCTION findGender(
    juminNum VARCHAR2
)
--함수는 반환값이 있어야 하므로 반환할 타입을 정의
RETURN VARCHAR2
IS
    --주민번호에서 성별에 해당하는 문자를 잘라 저장할 변수 선언
    genderCode VARCHAR2(1);
    --성별 판단 후 반환할 리턴값을 저장할 변수 선언
    result1 VARCHAR2(50);
BEGIN
    --주민번호에서 성별에 해당하는 문자를 잘라낸 후 변수에 저장
    genderCode := SUBSTR(juminNum, 8, 1);
    
    --if문으로 성별 판단
    IF genderCode = '1' OR genderCode = '3' THEN
        result1 := '남';
    ELSIF genderCode = '2' OR genderCode = '4' THEN
        result1 := '여';
    ELSE
        result1 := '너 누구여?';
    END IF;
    --함수는 반드시 반환값이 있어야 한다.
    RETURN result1;
END;
/

--실행확인
select findGender('999999-1000000') from dual; 
select findGender('999999-2000000') from dual;
select findGender('999999-3000000') from dual; 
select findGender('999999-4000000') from dual;
--한글은 보통 한글자에 3byte로 표현되므로 변수의 크기는 넉넉하게 설정하는
--것이 좋다. 따라서 return1을 varchar2(50)으로 설정한다.
select findGender('999999-5000000') from dual; 

/*시나리오] 사원의이름(first_name)을 매개변수로 전달받아서  
부서명(department_name)을 반환하는 함수를 작성하시오.
함수명 : func_deptName
*/

--1단계: 2개의 테이블을 조인해서 결과 확인
select first_name, last_name, department_id,department_name
from employees
    inner join departments using(department_id)
where first_name='Nancy';

--2단계: 함수 작성(사원의 이름을 인파라미터로 설정)
create or replace function func_deptName(
    --사원의 이름을 받아야하므로 문자타입으로 선언
    param_name varchar2
)
return 
    --부서명을 반환해야 하므로 문자타입으로 선언
    varchar2

is 
    --부서테이블의 부서명을 참조하는 참조변수 선언
    return_deptname departments.department_name%type;
begin
        --using을 사용한 내부조인을 통해 부서명을 인출하여 변수에 저장
    select department_name 
         into return_deptname
    from employees
        inner join departments using(department_id)
    where first_name=param_name;
    
    --인출된 부서명을 반환
    return return_deptname;
end;
/

select func_deptName('Nancy')from dual;
select func_deptName('Diana')from dual;


/*
3.트리거(Trigger)
    :자동으로 실행되는 프로시저로 직접 실행은 불가능하다.
    주로 테이블에 저장된 레코드의 변화가 있을떄 자동으로 실행된다    */
    
--트리거 실습을 위해 '부서'테이블을 복사한다
--오리지널 테이블은 레코드까지 모두 복사
create table trigger_dept_original
as
select * from departments where 1=1;

--백업 테이블은 레코드 없이 스키마(구조)만 복사
create table trigger_dept_backup
as
select * from departments where 1=0;
--레코드 확인
select * from trigger_dept_original; --레코드 27개 확인
select * from trigger_dept_backup; --레코드 없음


/*
시나리오] 테이블에 새로운 데이터가 입력되면 해당 데이터를 백업테이블에 저장하는
트리거를 작성해보자.
*/
create or replace trigger trig_dept_backup
    /*타이밍: after 이므로 이벤트 발생 후*/
    after
    /*이벤트: 레코드 입력 후 발생됨*/
    INSERT
    /*트리거를 적용할 테이블명*/
    on trigger_dept_original
    /*행 단위 트리거를 정의. 즉 하나의 행이 변화할떄마다 트리거가 실행된다.
    만약 테이블(문장) 단위 트리거로 정의하고 싶다면 해당 문장을 제거한다.
    이 경우 쿼리를 실행하면 트리거도 딱 한번만 실행된다.*/
    for each row
begin
/*insert 이벤트가 발생되면 true를 반환하여 if문이 실행된다.*/
    if Inserting then
    dbms_output.put_line('insert 트리거 발생됨');
    /*
    새로운 레코드가 입력되었으므로 임시테이블 :new에 저장되고
    해당 레코드를 통해 backpu 테이블에 입력할 수 있다.
    이와 같이 임시테이블은 행단위 트리거에서만 사용할 수 있다.*/
    insert into trigger_dept_backup
    values(
        :new.department_id,
        :new.department_name,
        :new.manager_id,
        :new.location_id
    );
    end if;
end;
/
--오리지날 테이블 레코드 삽입
insert into trigger_dept_original values (101, '개발팀', 10, 100);
insert into trigger_dept_original values (102, '전산팀', 20, 100);
--삽인된 레코드 확인
select * from trigger_dept_original;
--트리거를 통해 자동으로 백업된 레코드 확인
select * from trigger_dept_backup;






/*
시나리오] 원본테이블에서 레코드가 삭제되면 백업테이블의 레코드도 같이
삭제되는 트리거를 작성해보자.
*/

create or replace trigger trig_dept_delete
    /*'오리지날 테이블'에서 레코드를 '삭제'한 '이후' '행단위'로
    트리거를 적용한다.*/
    after
    delete
    on trigger_dept_original
    for each row
begin
    dbms_output.put_line('delete 트리거 발생됨');
    
    /*
    레코드가 삭제된 후 이벤트가 발생되어 트리거가 호출되므로
    :old 임시테이블을 사용한다.*/
    if deleting then
        delete from trigger_dept_backup
            where department_id=:old.department_id;
    end if;
end;
/
--레코드 확인하기
select * from trigger_dept_original;
select * from trigger_dept_backup;
--아래와 같이 레코드를 삭제하면 트리거가 자동 호출된다.
delete from trigger_dept_original where department_id=101;


--예제3] trigger_update_test

/*
For each row 옵션에 따른 트리거 실행횟수 테스트
생성1: 오리지날 테이블에 업데이트 이후 행단위로 발생되는 트리거 생성
*/
create or replace trigger trigger_update_test
    after update
    on trigger_dept_original
    for each row
begin
    if updating then
    /*update 이벤트가 감지되먄 백업 테이블에 레코드를 입력*/
    insert into trigger_dept_backup
    values(
        :old.department_id,
        :old.department_name,
        :old.manager_id,
        :old.location_id
    );
    end if;
end;
/
--5개의 레코드를 인출하는 select문 작성
select * from trigger_dept_original
    where department_id>10 and department_id<=50;
--위 조건을 그대로 update에 적용하여 시실행
update trigger_dept_original set department_name='5개 업댓'
    where department_id>10 and department_id<=50;

--레코드 확인하기
select * from trigger_dept_original;
select * from trigger_dept_backup;

/*
한번의 쿼리문 실행으로 5개의 레코드가 수정되었으므로, 백업테이블에도
5개의 레코드가 입력된다.
즉 행단위 트리거는 적용된 행의 갯수만큼 반복 실행된다.*/

/*생성2: 오리지날 테이블에 업데이트 이후 테이블(문장) 단위로 발생되는 트리거
    생성*/
create or replace trigger trigger_update_test
    after update
    on trigger_dept_original
    /**** for each row -> 이 부분 주석처리 ****/
begin
    if updating then
    /*update 이벤트가 감지되먄 백업 테이블에 레코드를 입력*/
    insert into trigger_dept_backup
    values(
    /*테이블 단위의 트리거에서는 임시테이블을 사용할 수 없다.
    따라서 임의의 값을 사용해야한다. 사용시 에러가 발생된다.*/
        /*** :old.department_id,
        :old.department_name,
        :old.manager_id,
        :old.location_id ***/
        999,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),99,9
    );
    end if;
end;
/
--위 조건을 그대로 update에 적용하여 시실행
update trigger_dept_original set department_name='5개 업댓2nd'
    where department_id>60 and department_id<=100;





























