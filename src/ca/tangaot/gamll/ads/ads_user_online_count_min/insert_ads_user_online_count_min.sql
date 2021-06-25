-- 每分钟在线用户数

USE gmall;

insert overwrite table ads_user_online_count_min
select *
from ads_user_online_count_min
union
select '2021-06-16' dt,
       mins,
       count(*)     cnt
from (
         select user_id,
                from_unixtime(session_start_timestamp + 60 * pos, 'yyyy-MM-dd HH:mm') mins
         from (
                  select session_id,
                         user_id,
                         unix_timestamp(from_unixtime(session_start_timestamp, 'yyyy-MM-dd HH:mm'),
                                        'yyyy-MM-dd HH:mm') session_start_timestamp,
                         unix_timestamp(from_unixtime(session_end_timestamp, 'yyyy-MM-dd HH:mm'),
                                        'yyyy-MM-dd HH:mm') session_end_timestamp
                  from (
                           select session_id,
                                  user_id,
                                  cast(min(page_start_time) / 1000 as bigint) session_start_timestamp,
                                  cast(max(page_end_time) / 1000 as bigint)   session_end_timestamp
                           from (
                                    select user_id,
                                           ts                                                                       page_start_time,
                                           ts + during_time                                                         page_end_time,
                                           concat(user_id, '-', last_value(session_start_point, true)
                                                                           over (partition by user_id order by ts)) session_id
                                    from (
                                             select user_id,
                                                    ts,
                                                    during_time,
                                                    if(last_page_id is null, ts, null) session_start_point
                                             from dwd_page_log
                                             where dt = '2021-06-16'
                                         ) t1
                                ) t2
                           group by session_id, user_id
                       ) t3
              ) t4
                  lateral view posexplode(
                          split(repeat(",", cast((session_end_timestamp - session_start_timestamp) / 60 as int)),
                                ",")) tmp as pos, item
     ) t5
group by mins;
