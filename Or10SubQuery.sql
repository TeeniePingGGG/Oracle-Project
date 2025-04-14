/***
파일명 : Or10SubQuery.sql
서브쿼리
설명 : 쿼리문 안에 또다른 쿼리문이 들어가는 형태의 select문
***/

/*
단일행 서브쿼리
형식] select * from 테이블명 where 컬럼=(
        select 컬럼 from 테이블명 where 조건
    );
    ※괄호안의 서브쿼리는 반드시 하나의 결과를 인출해야 한다.
*/

/*
시나리오] 사원테이블에서 전체사원의 평균급여보다 낮은 급여를 받는 사원들을 
추출하여 출력하시오.
    출력항목 : 사원번호, 이름, 이메일, 연락처, 급여
*/
--1.평균급여 구하기(결과 : 6462)
select round(avg(salary)) from employees;
--2.앞에서 구한 평균급여보다 낮은 직원들을 인출(결과 : 56명)
select * from employees where salary<6462;
/*1,2번을 아래와 같이 합쳐서 작성하면 에러가 발생한다.
문맥상 맞는 것처럼 보이지만 그룹함수를 단일행에 적용한 잘못된 쿼리문이다.*/
select * from employees where salary<round(avg(salary));
--3.서브쿼리문 작성
select * from employees where salary<(
    select round(avg(salary)) from employees
);

/*
시나리오] 전체 사원중 급여가 가장적은 사원의 이름과 급여를 출력하는 
서브쿼리문을 작성하시오.
출력항목 : 이름1, 이름2, 이메일, 급여
*/
--최소급여 확인(결과 : 2100)
select min(salary) from employees;
--그룹함수를 단일행에 사용했으므로 에러 발생
select 
    first_name, last_name, email, salary
from employees where salary=min(salary);
--2100불을 받은 직원을 인출
select 
    first_name, last_name, email, salary
from employees where salary=2100;
--2개의 쿼리문을 합쳐서 서브쿼리를 만든다.
select 
    first_name, last_name, email, salary
    from employees where salary=(
       select min(salary) from employees
);

/*
시나리오] 평균급여보다 많은 급여를 받는 사원들의 명단을 조회할수 있는 
서브쿼리문을 작성하시오.
출력내용 : 이름1, 이름2, 담당업무명, 급여
※ 담당업무명은 jobs 테이블에 있으므로 join해야 한다. 
*/
--평균급여 확인
select round(avg(salary)) from employees;
--jobs테이블과 내부조인하여 조건에 맞는 레코드 인출
select first_name, last_name, job_title, salary
from employees Em inner join jobs Jo
    on Em.job_id=Jo.job_id
where salary>6462;
--서브쿼리문으로 병합, inner join에서 on절을 using으로 변경
select 
    first_name, last_name, job_title, salary
from employees
    inner join jobs
        using(job_id)
where salary>(
    select round(avg(salary)) from employees 
);

/*
복수행 서브쿼리
형식] select * from 테이블명 where 컬럼 in (
        select 컬럼 from 테이블명 where 조건
      );
    ※괄호안의 서브쿼리는 2개이상의 결과를 인출해야 한다.
    ※경우에 따라 1개의 결과가 나오더라도 에러가 발생하진 않는다.
*/

/*
시나리오] 담당업무별로 가장 높은 급여를 받는 사원의 명단을 조회하시오.
    출력목록 : 사원아이디, 이름, 담당업무아이디, 급여
*/
--담당업무별로 가장 높은 급여를 확인
select job_id, max(salary) 
from employees
group by job_id;
--group by로 그룹화되어있으므로 단일컬럼은 사용할 수 없어 에러 발생
select job_id, max(salary), first_name 
from employees group by job_id;
--앞에서 나온 결과를 바탕으로 단순한 or조건으로 쿼리문 작성
select 
    employee_id, first_name, job_id, salary
from employees where
    (job_id='AD_PRES' and salary=2400) or
    (job_id='AD_VP' and salary=17000) or
    (job_id='IT_PROG' and salary=9000) or
    (job_id='FI_MGR' and salary=12008);
/*앞의 쿼리에서 19개의 결과가 인출되었지만 쿼리를 직접 기술하는 것은 불가능하므로 4개만으로 결과를 확인해본다.*/

select 
    employee_id, first_name, job_id, salary
from employees where
    (job_id, salary) in (
        select job_id, max(salary) 
        from employees
        group by job_id
    );
/*
복수행 연산자 : any
    메인쿼리의 비교조건이 서브쿼리의 검색결과와 하나 이상 일치하면 true가 되는 연산자.
    즉 둘중 하나만 만족하면 해당 레코드를 인출한다.
*/

/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 둘 중 하나만
    만족하더라도 인출하시오. 
*/
--20번 부서의 급여를 확인(결과 : 6000, 13000)
select * from employees where department_id=20;
--위 결과를 단순한 or절로 쿼리문 작성 (결과 : 55개)
select first_name, salary from employees
where salary>6000 or salary>13000;
--위 2개의 쿼리문을 서브쿼리문으로 작성
select first_name, salary from employees
where salary > any (
    select salary from employees where department_id=20
);
/*
    결과로 인출된 2개의 급여 중 하나만 만족하면 되므로 복수행 연산자 any를 이용해서 서브쿼리문을 작성한다.
    즉 여기서는 6000이상의 조건에 만족하는 모든 레코드가 인출된다.
*/

/*
복수행 연산자 : all
    메인쿼리의 비교조건이 서브쿼리의 검색결과와 모두 일치해야 레코드를 인출한다.
*/

/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 둘다 만족하는 
    레코드만 인출하시오. 
*/
select first_name, salary from employees
where salary>6000 and salary>13000;

select first_name, salary from employees
where salary > all (
    select salary from employees where department_id=20
);
/*
    6000보다도 크고 동시에 13000보다도 커야 하므로 결과적으로 13000보다 큰 레코드만 인출된다.
    결과 : 5개
*/

/*
rownum : 테이블에서 레코드를 조회한 순서대로 순번이 부여되는 가상의 컬럼을 말한다.
        해당 컬럼은 모든 테이블에 논리적으로 존재한다. 
*/
--모든 계정에 논리적으로 존재하는 테이블
select * from dual;
--레코드를 정렬없이 모든 레코드를 가져와서 rownum을 부여한다. 이 경우 rownum은 순서대로 인출된다.
select employee_id, first_name, rownum from employees;
--이름이나 사원번호를 통해 정렬하면 rownum이 섞여져 나오기도 하고 순서대로 나오기도 한다.
select employee_id, first_name, rownum from employees
order by first_name;

select employee_id, first_name, rownum from employees
order by employee_id;

/*
rownum을 우리가 정렬한 순서대로 재부여하기 위해 서브쿼리를 이용한다.
from절에는 테이블이 위치해야 하지만, 아래의 서브쿼리에서는 사원테이블의 전체레코드를 대상으로 하되 
이름으로 정렬된 상태로 레코드를 인출하기 때문에 테이블을 대체할 수 있다.
또한 정렬된 상태에서 rownum을 부여하므로 순차적인 순번이 된다.
*/
select first_name, rownum from
    (select * from employees order by first_name asc); 

/*이름을 기준으로 정렬된 레코드에 rownum을 부여했으므로 
where절에 아래와 같은 조건을 부여해서 구간을 결정할 수 있다.*/
select * from
    (select tb.*, rownum from
        (select * from employees order by first_name asc) tb)
where rownum>=1 and rownum<=10;
--rownum에 별칭을 부여해서 조건으로 사용한다.
select * from
    (select tb.*, rownum rNum from
        (select * from employees order by first_name asc) tb)
/*where rNum>=1 and rNum<=10;*/
/*where rNum>=11 and rNum<=20;*/
where rNum between 21 and 30;
--구간을 정할 때는 between을 사용해도 된다.
-------------------------------------------------------------------------
/*01.사원번호가 7782인 
사원과 담당 업무가 같은 사원을 표시(사원이름과 담당 업무)하시오.*/
select * from emp where empno=7782;
select * from emp where job='MANAGER';
--위 2개의 쿠리문을 병합해서 서브쿼리로 작성
select * from emp where job=(select job from emp where empno=7782);

/*02.사원번호가 7499인 사원보다 
급여가 많은 사원을 표시(사원이름과 담당 업무)하시오.
*/
select * from emp where empno=7499;
select * from emp where sal>1600;
select * from emp where sal>(select sal from emp where empno=7499);

/*03.최소 급여를 받는 사원의 이름, 
담당 업무 및 급여를 표시하시오(그룹함수 사용).*/
select min(sal) from emp;
select * from emp where sal=800;

select empno, ename, job, sal 
from emp 
where sal=(select min(sal) from emp);

/*04.평균 급여가 가장 적은 직급(job)과 평균 급여를 표시하시오.*/

--직급별 평균 급여 인출
select job, avg(sal)
    from emp group by job;

--오류발생. 그룹함수를 2개 겹쳤기 때문에 job컬럼을 제외해야함.
select job, min(avg(sal)) from emp group by job;

--정상실행됨. 직급중 평균급여가 최소인 레코드 인출
select min(avg(sal)) from emp group by job;

/*
평균급여는 물리적으로 존재하는 컬럼이 아니므로 where절에는 사용할 수 없고
having절에 사용해야한다. 즉 평균금여가 1017인 직급을 출력하는
방식으로 서브쿼리를 작성해야한다.*/
select job, avg(sal)
from emp group by job
    having avg(sal) = (select min(avg(sal)) from emp group by job);



/*05.각부서의 최소 급여를 받는 사원의 이름, 급여, 부서번호를 표시하시오.*/

--단순 정렬을 통해 부서별 급여 확인
select deptno, sal 
from emp 
    order by deptno, sal;

--그룹함수를 통해 부서별 최소급여 확인
select deptno, min(sal)
from emp
    group by deptno;

--단순 or절로 쿼리문 작성 후 인출
select ename, sal, deptno 
from emp
where (deptno=20 and sal=800)
    or (deptno=30 and sal=950)
    or (deptno=10 and sal=1300);


/*
부서번호로 그룹화 해서 최소 급여를 얻어온 후 복수행 연산자 in으로
연결해서 서브쿼리문 작성 후 인출*/
select ename, sal, deptno 
from emp
where (deptno,sal) in (

    select deptno, min(sal)
    from emp
        group by deptno
);


/*06.담당 업무가 분석가(ANALYST)인 사원보다 급여가 적으면서
업무가 분석가(ANALYST)가 아닌 
사원들을 표 시(사원번호, 이름, 담당업무, 급여)하시오.*/

select * from emp where job='ANALYST'; --해당 업무의 급여는 3000
select * from emp where job<> 'ANALYST' and sal<3000;

/*
담당업무가 ANALYST인 경우에는 인출한 결과가 1개이므로 아래와 같이 단일행
연산자로 서브쿼리를 만들 수 있다.*/
select empno, ename, job, sal 
from emp
where job<> 'ANALYST' and sal<(select sal from emp where job='ANALYST');


--담당업무를 salerman으로 변경하면 4개의 레코드가 인출된다
select * from emp where job='ANALYST';
/*
따라서 단일행 연산자로 쿼리문을 작성하면 에러가 발생되므로
복수행 연산자 all 혹은 any를 사용해야한다.*/
select empno, ename, job, sal 
from emp
where job<> 'SALESMAN' and sal< all(select sal from emp where job='SALESMAN');


/*07.이름에 K가 포함된 사원과 
같은 부서에서 일하는 사원의 사원번호와 이름을 표시하는 질의를 작성하시오*/

select * from emp where ename like '%K%';
--or절 대신 in을 사용하면 컬럼명의 중복을 제거할 수 있다.
select * from emp where deptno in (10,30);

/*2개 이상의 결과를 인출하는 서브쿼리이므로 복수행 연산자 in을 사용해서
쿼리문을 작성해야한다.*/
select empno, ename, deptno 
from emp 
where deptno in (
    select deptno 
    from emp 
    where ename like '%K%'
);

/*08.부서 위치가 DALLAS인 사원의 이름과 부서번호 및 담당 업무를 표시하시오.*/

select * from dept where loc='DALLAS';
select * from emp where deptno=20;

select ename, deptno, job from emp 
where deptno=
(   select deptno 
    from dept 
    where loc='DALLAS'
);


/*09.평균 급여 보다 많은 급여를 받고 이름에 K가 포함된 사원과 
같은 부서에서 근무하는 사원의 사원번호, 이름, 급여를 표시하시오.*/

--평균급여
select avg(sal) from emp; --2077.xx
--k가 포함된 사원
select * from emp where ename like '%K%'; --10, 30
--단순 조건으로 쿼리문 작성
select * from emp where sal>2077 and deptno in(10,30);

--서브쿼리문으로 작성
select * from emp where sal>(select avg(sal) from emp) 
    and deptno in(select deptno from emp where ename like '%K%');

/*10.담당 업무가 MANAGER인 
사원이 소속된 부서와 동일한 부서의 사원을 표시하시오.*/
select * from emp where job='MANAGER'; --10,20,30
--3개의 레코드가 인출되므로 복수행 연산자 in을 사용
select * from emp 
    where deptno in(select * from emp where job='MANAGER')

/*11.BLAKE와 동일한 부서에 속한 사원의 이름과 입사일을 
표시하는 질의를 작성하시오(단. BLAKE는 제외)
*/

select * from emp where ename='BLAKE'; --30
--30번 부서이면서 BLAKE가 아닌 레코드
select * from emp where deptno=30 and ename<>'BLAKE';

select * from emp where deptno=(select deptno from emp where ename='BLAKE')
    and ename<> 'BLAKE';

















