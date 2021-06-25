-- 品牌复购率（最近三十天）

USE gmall;

insert overwrite table ads_repeat_purchase
select *
from ads_repeat_purchase
union
select '2021-06-16' dt,
       tm_id,
       tm_name,
       cast(sum(if(order_count >= 2, 1, 0)) / sum(if(order_count >= 1, 1, 0)) * 100 as decimal(16, 2))
from (
         select user_id,
                tm_id,
                tm_name,
                sum(order_count) order_count
         from (
                  select user_id,
                         sku_id,
                         count(*) order_count
                  from dwd_order_detail
                  where dt >= date_add('2021-06-16', -29)
                  group by user_id, sku_id
              ) t1
                  left join
              (
                  select id,
                         tm_id,
                         tm_name
                  from dim_sku_info
                  where dt = '2021-06-16'
              ) t2
              on t1.sku_id = t2.id
         group by user_id, tm_id, tm_name
     ) t3
group by tm_id, tm_name;
