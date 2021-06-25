-- 用户变动统计

USE gmall;

insert overwrite table ads_user_change
select *
from ads_user_change
union
select churn.dt,
       user_churn_count,
       user_back_count
from (
         select '2021-06-16' dt,
                count(*)     user_churn_count
         from dwt_user_topic
         where dt = '2021-06-16'
           and login_date_last = date_add('2021-06-16', -7)
     ) churn
         join
     (
         select '2021-06-16' dt,
                count(*)     user_back_count
         from (
                  select user_id,
                         login_date_last
                  from dwt_user_topic
                  where dt = '2021-06-16'
                    and login_date_last = '2021-06-16'
              ) t1
                  join
              (
                  select user_id,
                         login_date_last login_date_previous
                  from dwt_user_topic
                  where dt = date_add('2021-06-16', -1)
              ) t2
              on t1.user_id = t2.user_id
         where datediff(login_date_last, login_date_previous) >= 8
     ) back
     on churn.dt = back.dt;

