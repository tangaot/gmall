-- 路径分析

USE gmall;

insert overwrite table ads_page_path
select *
from ads_page_path
union
select '2021-06-16',
       source,
       target,
       count(*)
from (
         select concat('step-', step, ':', source)     source,
                concat('step-', step + 1, ':', target) target
         from (
                  select page_id                                                           source,
                         lead(page_id, 1, null) over (partition by session_id order by ts) target,
                         row_number() over (partition by session_id order by ts)           step
                  from (
                           select last_page_id,
                                  page_id,
                                  ts,
                                  concat(mid_id, '-', last_value(if(last_page_id is null, ts, null), true)
                                                                 over (partition by mid_id order by ts)) session_id
                           from dwd_page_log
                           where dt = '2021-06-16'
                       ) t1
              ) t2
     ) t3
group by source, target;
