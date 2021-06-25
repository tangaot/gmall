-- 商品统计

USE gmall;

insert overwrite table ads_order_spu_stats
select *
from ads_order_spu_stats
union
select '2021-06-16' dt,
       spu_id,
       spu_name,
       tm_id,
       tm_name,
       category3_id,
       category3_name,
       category2_id,
       category2_name,
       category1_id,
       category1_name,
       sum(order_last_1d_count),
       sum(order_last_1d_final_amount)
from (
         select sku_id,
                order_last_1d_count,
                order_last_1d_final_amount
         from dwt_sku_topic
         where dt = '2021-06-16'
     ) t1
         left join
     (
         select id,
                spu_id,
                spu_name,
                tm_id,
                tm_name,
                category3_id,
                category3_name,
                category2_id,
                category2_name,
                category1_id,
                category1_name
         from dim_sku_info
         where dt = '2021-06-16'
     ) t2
     on t1.sku_id = t2.id
group by spu_id, spu_name, tm_id, tm_name, category3_id, category3_name, category2_id, category2_name, category1_id,
         category1_name;
