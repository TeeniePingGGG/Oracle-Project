/*
파일명: 03String.sql
문자열 처리 함수
설명: 문자열에 대해 대소문자를 반환하거나, 문자열의 길이, 자르기 등
	문자열을 조작하는 함수
*/

/*
concat(문자열1, 문자열2)
: 문자열 1,2를 서로 연결해서 출력. 문자열 부분은 컬럼명으로 사용할 수 있음
방법1: concat(문자열1, 문자열2)
방법2: 문자열1 || 문자열2
*/
select concat('Good','morning') from dual;
select 'Good' || 'morning' from dual;

--여러 문장을 연결하는 경우에는 연산자가 좀 더 편리하다.
select 'Oracle ' || '21c ' || 'Good..!' from dual;

-- => 위 SQL문은 concat() 함수로 변경하면, 반복해서 써야하므로 불편하다.
select concat concat(('Oracle ', '21c '),'Good..!') from dual;

/*
시나리오] 사원테이블에서 사원의 이름을 연결해서 아래와 같이 출력하시오
    출력내용 : first+last name, 급여, 부서번호 
*/
--1단계
select first_name, last_name, salary, department_id from employees;

--2단계: 이름 부분을 연결
select concat(first_name, last_name), salary, department_id from employees;

--3단계: 이름 사이에 스페이스가 없어 다독성이 떨어지므로 추가
select concat(first_name || ' ', last_name), salary, department_id 
	from employees;

--4단계; 컬럼명이 너무 길게 출력되므로 별칭 부여
select concat(first_name || ' ', last_name) as full_name, salary, department_id 
	from employees;


/*
initcap(문자열): 문자열의 첫글자만 대문자로 변환
lower() , upper(): 소문자, 대문자로 변환
*/
select initcap('good'), lower('MORning'), upper('sIR') from dual;


/*
시나리오] 사원테이블에서 frist_name이 john인 사원을 찾아 출력하시오
*/
--이와 같이 쿼리하면 결과가 인출되지 않는다. 데이터는 대소문자를 구분하기 때문이다
select * from employees where fist_name='john' ; 

--입력값의 첫글자만 대문자로 변경 후 쿼리한다
select * from employees where fist_name=initcap('john') ; 

--컬럼에 함수를 적용하면 레코드 자체를 소문자로 변경 후 조건으로 사용한다
select * from employees where lower(fist_name)='john' ; 

--레코드와 입력값 전체를 대문자로 변경 후 조건으로 사용한다.
select * from employees where upper(fist_name)=upper('john') ;

/*
lpad(), rpad()
:문자열의 왼쪽, 오른쪽을 특정한 기호로 채울떄 사용
형식] lpad('문자열', '전체자리수', '채울문자' )
	=> 전체자리수에서 문자열의 길이 만큼을 제외한 나머지 좌(우)측
	    부분을 주어진 문자로 채워준다.
*/ 
--전체 7글자 중 왼쪽 혹은 오른쪽을 #으로 채운다
--세번쨰 인수가 없는 경우에는 공백(스페이스)로 빈공간을 채운다.
select 'good', lpad('good', 7, '#'), rpad('good', 7, '#'), lpad('good', 7)
	from dual;


/*
시나리오] 사원의 이름을 10글자로 간주하며 나머지 부분을 *로 채우시오
*/
select rpad(first_name, 10, '*') from employees;


/*
trim() : 공백을 제거할때 사용
형식] trim( [leading | trailing | both]  제거할 문자 from 컬럼)
	- leading: 좌측의 공백 제거
	- trailing : 우측
	- both : 양쪽에서 제거(default값)
--양쪽 끝의 문자만 제거되고, 중간의 문자는 제거할 수 없다.
--'문자'만 제거할 수 있고, '문자열'은 제거할 수 없다.
*/
select
    trim('다' from '다람쥐가 나무를 탑니다')/*양쪽의 '다' 제거*/
    ,trim(both '다' from '다람쥐가 나무를 탑니다')/*both는 디폴트값*/
    ,trim(leading'다' from '다람쥐가 나무를 탑니다')/*좌측 문자 제거*/
    ,trim(trailing '다' from '다람쥐가 나무를 탑니다')/*우측 문자 제거*/
    ,trim(' 다람쥐가 나무를 탑니다 ')/*양쪽의 공백 제거*/
from dual;

select
--문자열은 제거할 수 없으므로 에러가 발생한다.
    trim('다람쥐' from '다람쥐가 나무를 탑니다') from dual;

/*
ltrim(), rtrim()
:좌측, 우측의 '문자' 혹은 '문자열'을 제거할 때 사용.
그리고 공백도 제거할 수 있다.
*/
select 
    ltrim(' 좌측공백제거 ')/*좌측의 공백만 제거됨*/
    
    /*좌측에 공백이 포함되어있어 문자열이 삭제되지 않는다.*/
    ,ltrim(' 좌측공백제거 ','좌측')
    
    /*이 경우 2개의 함수를 중첩해서 사용하여 기능을 수행할 수 있다*/
    ,ltrim(trim(' 좌측공백제거 '),'좌측')
from dual;

/*
substr(): 문자열에서 시작인덱스부터 길이만큼 잘라서 문자열을 출력
    형식] substr(컬럼, 시작인덱스, 길이)
    
    참고1] 오라클의 인덱스는 1부터 시작한다. 0부터 아님
    참고2]'길이'에 해당하는 인수가 없으면 문자열의 끝까지를 의미한다.
    참고3] 시작인덱스가 음수면 우측끝부터 좌로 인덱스를 적용한다.
*/
select substr('good morning john',8,4) from dual;--rnin
select substr('good morning john',8) from dual; --r부터 끝까지

--문자열의 길이를 반환
select length('good morning john') from dual;


/*
시나리오] 사원테이블의 first_name을 첫글자를 제외한 나머지 부분을
    *로 마스킹 처리하는 쿼리문을 작성하시오
*/
--1.이름의 첫글자만 출력(인덱스 1부터 1글자를 자름)
select first_name, substr(first_name,1,1) from employees;

--2.이름을 10자로 간주하여 나머지 부분을 *로 채워보기
select rpad(first_name,10,'*') from employees;

/*
이름의 첫글자를 잘라내고, 이름의 길이(length)를 얻어온다. 이를 통해
*를 출력하면 첫글자를 제외한 남은 길이만큼 마스킹 처리할 수 있다.*/ 
select 
    first_name,
    rpad(substr(first_name,1,1),length(first_name),'*')
    from employees;


/*
replace() : 문자열을 다른 문자열로 대체할 떄 사용한다. 만약 공백으로
    문자열을 대체한다면 해당 문자열을 삭제하는 결과가 된다.
    형식] replace(컬럼명 or 문자열, '변경 대상의 문자', '변경할 문자')
※trim(), ltrim(), rtrim()의 기능을 replace()하나로
대체할 수 있으므로 trim()에 비해 replace()가 훨씬 더 사용빈도가 높다.
*/
--특정 문자열을 변경
select replace('good morning john','morning','evening') from dual;

--문자열 삭제
select replace('good morning john','morning','') from dual;

--trim과 같은 역할이지만, 문자열 중간의 공백도 제거할 수 있다.
select replace('good morning john',' ','') from dual;

/*
instr(): 문자열에서 특정문자가 위치한 인덱스를 찾아 반환한다.
    형식1] instr(컬럼명, '찾을문자')
        문자열의 처음부터 문자를 찾는다.
    형식2] instr(컬럼명, '찾을문자', '탐색을 시작할 인덱스', '몇번쨰 문자');
        탐색을 시작할 인덱스부터 문자를 찾는다. 단, 찾는 문자중 몇번쨰에 있는
        문자인지 지정할 수 있다
※탐색을 시작할 인덱스가 음수인경우 우측에서 좌측으로 찾게된다.        
*/
--n이 발견된 첫번쨰 인덱스 인출
select  instr('good morning john','n') from dual;
--인덱스 1부터 탐색을 시작해서 n이 나오는 두번쨰 인덱스 인출
select  instr('good morning john','n',1,2) from dual;
--인덱스 10부터 탐색을 시작해서 n이 나오는 두번쨰 인덱스 인출
select  instr('good morning john','n',10,2) from dual;





