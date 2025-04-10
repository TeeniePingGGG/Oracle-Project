/*
파일명: Or16SubProgram.sql
서브프로그램
설명: 저장프로시저, 함수 그리고 자동으로 실행되는 프로시저인
    트리거를 학습한다.*/
    
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
select * from user_source where name like upper('%pcd_emp_salary% ');

--만약 첫 실행이라면 최초 한번 실행해준다.
set serveroutput on;
--프로시저의 호출은 호스트환경에서 execute 명령을 이용한다.
execute pcd_emp_salary;

















































































