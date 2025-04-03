/*
파일명: Or05Date.sql
날짜함수
설명: 년, 월, 일, 시 분초의 포맷으로 날짜형식을 지정하거나 날짜를
    계산할때 사용하는 함수
*/
/*
months_between(): 현재날짜와 기준날짜 사이의 개월수를 반환한다
    형식] months_between(현재날짜, 기준날짜[과거]);
*/
select
    months_between(sysdate, '2024-01-01'),
     ceil(months_between(sysdate, '2024-01-01'))"올림처리",
      floor(months_between(sysdate, '2024-01-01'))"버림처리"
from dual;

/*
퀴즈] 만약 "2020년01월01일" 문자열을 그대로 적용해서 개월수를 계산하려면??
*/
/*
"2020년 01월 01일"이 문자열은 날짜의 형식으로 인식되지 않으므로 to_date를 통해
날짜형식으로 변환해야한다. 또한 날짜서식이 사이에 한글은 허용되지 않으므로 더블쿼테이션
으로 감싸줘야 한다.*/
select
    months_between(sysdate,to_date('2020년01월01일','yyyy"년"mm"월"dd"일"'))
from dual;

/*
last_day(): 해당월의 마지막 날짜를 반환한다.
*/
select
    last_day('22-04-03'), --4월은 30일까지 있음
    last_day('24-02-01'), --24년은 윤년이므로 29일 출력
    last_day('25-02-01') --일반적으로 2월은 28일까지 있음  
from dual;

--컬럼이 date 타입인 경우 간단한 날짜연산이 가능하다.
select 
    sysdate "오늘", 
    sysdate+1 "내일",
    sysdate-7 "일주일전"
from dual;        
    






