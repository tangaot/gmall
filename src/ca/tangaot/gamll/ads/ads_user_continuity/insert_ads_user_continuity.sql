-- 七天内连续三天活跃用户数

USE gmall;

insert overwrite table ads_user_continuity
select *
from ads_user_continuity
union
select '2021-06-16' dt,
       count(distinct (user_id))
from (
         select user_id
         from (
                  select user_id,
                         date_sub(dt, rk) diff
                  from (
                           select user_id,
                                  dt,
                                  rank() over (partition by user_id order by dt) rk
                           from dws_user_action_daycount
                           where dt >= date_add("2021-06-16", -6)
                       ) t1
              ) t2
         group by user_id, diff
         having count(*) >= 3
     ) t3;

