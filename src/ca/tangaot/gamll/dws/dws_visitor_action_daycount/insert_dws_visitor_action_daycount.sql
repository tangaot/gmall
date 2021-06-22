-- 访客主题

USE gmall;

insert overwrite table dws_visitor_action_daycount partition (dt = '2021-06-16')
select t1.mid_id,
       t1.brand,
       t1.model,
       t1.is_new,
       t1.channel,
       t1.os,
       t1.area_code,
       t1.version_code,
       t1.visit_count,
       t3.page_stats
from (
         select mid_id,
                brand,
                model,
                if(array_contains(collect_set(is_new), '0'), '0', '1') is_new,--ods_page_log中，同一天内，同一设备的is_new字段，可能全部为1，可能全部为0，也可能部分为0，部分为1(卸载重装),故做该处理
                collect_set(channel)                                   channel,
                collect_set(os)                                        os,
                collect_set(area_code)                                 area_code,
                collect_set(version_code)                              version_code,
                sum(if(last_page_id is null, 1, 0))                    visit_count
         from dwd_page_log
         where dt = '2021-06-16'
           and last_page_id is null
         group by mid_id, model, brand
     ) t1
         join
     (
         select mid_id,
                brand,
                model,
                collect_set(named_struct('page_id', page_id, 'page_count', page_count, 'during_time',
                                         during_time)) page_stats
         from (
                  select mid_id,
                         brand,
                         model,
                         page_id,
                         count(*)         page_count,
                         sum(during_time) during_time
                  from dwd_page_log
                  where dt = '2021-06-16'
                  group by mid_id, model, brand, page_id
              ) t2
         group by mid_id, model, brand
     ) t3
     on t1.mid_id = t3.mid_id
         and t1.brand = t3.brand
         and t1.model = t3.model;
