-- 用户留存率

USE gmall;

insert overwrite table ads_user_retention
select *
from ads_user_retention
union
select '2021-06-16',
       login_date_first                                                                       create_date,
       datediff('2021-06-16', login_date_first)                                               retention_day,
       sum(if(login_date_last = '2021-06-16', 1, 0))                                          retention_count,
       count(*)                                                                               new_user_count,
       cast(sum(if(login_date_last = '2021-06-16', 1, 0)) / count(*) * 100 as decimal(16, 2)) retention_rate
from dwt_user_topic
where dt = '2021-06-16'
  and login_date_first >= date_add('2021-06-16', -7)
  and login_date_first < '2021-06-16'
group by login_date_first;
