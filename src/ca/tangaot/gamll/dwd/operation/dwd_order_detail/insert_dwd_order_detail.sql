-- 订单明细事实表

USE gmall;

insert overwrite table dwd_order_detail partition(dt='2021-06-17')
select
    od.id,
    od.order_id,
    oi.user_id,
    od.sku_id,
    oi.province_id,
    oda.activity_id,
    oda.activity_rule_id,
    odc.coupon_id,
    od.create_time,
    od.source_type,
    od.source_id,
    od.sku_num,
    od.order_price*od.sku_num,
    od.split_activity_amount,
    od.split_coupon_amount,
    od.split_final_amount
from
    (
        select
            *
        from ods_order_detail
        where dt='2021-06-17'
    )od
        left join
    (
        select
            id,
            user_id,
            province_id
        from ods_order_info
        where dt='2021-06-17'
    )oi
    on od.order_id=oi.id
        left join
    (
        select
            order_detail_id,
            activity_id,
            activity_rule_id
        from ods_order_detail_activity
        where dt='2021-06-17'
    )oda
    on od.id=oda.order_detail_id
        left join
    (
        select
            order_detail_id,
            coupon_id
        from ods_order_detail_coupon
        where dt='2021-06-17'
    )odc
    on od.id=odc.order_detail_id;
