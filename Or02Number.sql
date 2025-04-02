/*
파일명:Or02Number.sql
숫자(수학) 관련 함수
설명: 숫자데이터를 처리하기 위한 숫자관련 함수를 학습
    테이블 생성시 number 타입으로 선언된 컬럼에 저장된 데이터를
    대상으로 한다.
*/
--현재 접속한 계정에 생성되어 있는 테이블과 뷰의 목록을 보여준다.
select * from tab;

--물리적으로 존재하는 테이블인 경우 정상적으로 레코드가 인출된다.
select * from employees;

--존재하지 않는 테이블이라면 쿼리에러가 발생된다.
select * from kosmo;

/*
Dual테이블
: 하나의 행으로 결과를 출력하기 위해 제공되는 테이블로 오라클에서
자동으로 생성되는 논리적 테이블이다.
varchar2(1)로 정의된 dummy라는 단 하나의 컬럼으로 구성되어있다.*/
select * from dual;




/*
abs(): 절대값 구하기*/
select abs(12000) from dual;
select abs(-7000) from dual;
-- 앞으로 학습하는 모든 함수는 물리적인 테이블에 적용할 수 있다.
select abs(salary) "급여의 절대값" from employees;

/*
truc(): 소수점을 특정자리수에 잘라낼때 사용
	형식] trunc(컬럼명 혹은 값, 소수점이하 자리)
	두번쨰 인수가
	양수: 주어진 숫자만큼 소수점을 표현
	없을때: 정수부만 표현. 즉 소수점 아래부분을 버림
	음수: 정수부를 숫자만큼 잘라 나머지를 0으로 채움*/
select trunc(12345.12345,2) from dual;  --12345.12 출력

select trunc(12345.12345,2) from dual; --12345

select trunc(12345.12345,2) from dual; --12300

/*
시나리오] 사원테이블에서 영업사원의 급여에 대한 커미션을 계산하여 합한결과를 
    출력하는 쿼리문을 작성하시오. 
    Ex) 급여:1000, 보너스율:0.1
        => 1000 + (1000*0.1) = 1100 
*/
--1. 영업사원을 찾아 인출한다. (영업사원의 Job_id는 SA_XX로 되어있다)
select * from employees where job_id like 'SA_%' ;
--또는 영업사원은 커미션이 있으므로 commission_pct is not null로도 인출할 수 있다.


--2. 커미션을 계산해서 이름과 함께 출력한다.
select frist_name, salary, commission_pct, salary+(salary*commission_pct)
	 from employees where job_id like 'SA_%' ;

--3. 커미션을 소수점 1자리로 만든 후 금액 계산하기
select frist_name, salary, trunc(commission_pct,1), 
	salary+(salary*trunc(commission_pct,1))
	 from employees where job_id like 'SA_%' ;

--4. 계산식이 포함된 컬럼명에 별칭 부여
select frist_name, salary, trunc(commission_pct,1) as comm_pct, 
	salary+(salary*trunc(commission_pct,1)) TotalSalary
	 from employees where job_id like 'SA_%' ;

/*
소수점 관련함수
	ceil(): 소수점이하는 무조건 올림처리
	floor(): 무조건 버림처리
	round(값, 자리수): 반올림 처리
		두번쨰 인수가 없는 경우: 소수점 첫째 자리가 5이상이면 올림, 미만이면 버림
			       있는 경우: 숫자만큼 소수점이 표현되므로 그 다음수가 5이상이면
					올림, 미만이면 버림*/
select ceil(32.8) from dual;
select ceil(32.8) from dual; --모두 33인출

select floor(32.8) from dual;
select floor(32.8) from dual; --모두 32인출

--소수점 첫째자리에서 결정되므로 0과 1이 인출된다.
select round(0.123), round(0.543)  from dual; 

/*
첫번쨰 항목: 소수이하 6자리까지 표현되므로 7을 올림처리
두번쨰 항목: 소수이하 4자리까지 표현되므로 1을 버림처리*/
select round(0.1234567,6), round(0.345612,4)  from dual; 

/*
mod(): 나머지를 구하는 함수
power(): 거듭제곱을 구하는 함수
sqrt(): 제곱근(루트)을 구하는 함수
*/
select mod(99,4) "99를 4로 나눈 나머지" from dual;

select power(2,10) "2의 10승" from dual;

select sqrt(49) "49의 제곱근" from dual;










