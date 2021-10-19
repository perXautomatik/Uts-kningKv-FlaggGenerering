.read attatch DittoDb.sql;


select * from Main where length(mText) < 3;

select mText, count(*) c

from main group by mText order by c desc;

select * from data order by ooData desc limit 10;

select strClipBoardFormat, count(*) c from data group by strClipBoardFormat order by c desc;

select * from data where strClipBoardFormat in ('CF_DIB',
'CF_HDROP'
)

select * from main where mText like '%bing%' OR mText like '%xhamster%' OR mText like '%nudevista%' OR mText like '%pornsos%'
order by mText
;

select mText,count(*) c from main where mText like 'C:\%' OR mText like 'E:\%'
group by mtext order by c desc,mText
;

