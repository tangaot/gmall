-- 各地区订单统计

USE gmall;

insert overwrite table ads_order_by_province
select *
from ads_order_by_province
union
select '2021-06-16' dt,
       province_id,
       province_name,
       area_code,
       iso_code,
       iso_3166_2,
       order_last_1d_count,
       order_last_1d_final_amount
from (
         select province_id,
                order_last_1d_count,
                order_last_1d_final_amount
         from dwt_area_topic
         where dt = '2021-06-16'
     ) t1
         left join
     (
         select id,
                province_name,
                area_code,
                iso_code,
                iso_3166_2
         from dim_base_province
     ) t2
     on t1.province_id = t2.id;
