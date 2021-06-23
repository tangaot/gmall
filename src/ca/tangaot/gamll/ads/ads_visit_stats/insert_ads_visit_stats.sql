-- 访客统计

USE gmall;

insert overwrite table ads_visit_stats
select *
from ads_visit_stats
union
select '2021-06-16'                                                           dt,
       is_new,
       channel,
       count(distinct (mid_id))                                               uv_count,
       cast(sum(duration) / 1000 as bigint)                                   duration_sec,
       cast(avg(duration) / 1000 as bigint)                                   avg_duration_sec,
       sum(page_count)                                                        page_count,
       cast(avg(page_count) as bigint)                                        avg_page_count,
       count(*)                                                               sv_count,
       sum(if(page_count = 1, 1, 0))                                          bounce_count,
       cast(sum(if(page_count = 1, 1, 0)) / count(*) * 100 as decimal(16, 2)) bounce_rate
from (
         select session_id,
                mid_id,
                is_new,
                channel,
                count(*)         page_count,
                sum(during_time) duration
         from (
                  select t1.mid_id,
                         channel,
                         is_new,
                         last_page_id,
                         page_id,
                         during_time,
                         concat(t1.mid_id, '-', last_value(if(last_page_id is null, ts, null), true)
                                                           over (partition by t1.mid_id order by ts)) session_id
                  from (
                           select mid_id,
                                  channel,
                                  last_page_id,
                                  page_id,
                                  during_time,
                                  dt,
                                  ts
                           from dwd_page_log
                           where dt = '2021-06-16'
                       ) t1
                           left join
                       (
                           select mid_id,
                                  if(visit_date_first = '2021-06-16', '1', '0') is_new
                           from dwt_visitor_topic
                           where dt = '2021-06-16'
                       ) t2
                       on t1.mid_id = t2.mid_id
              ) t3
         group by session_id, mid_id, is_new, channel
     ) t6
group by is_new, channel;
