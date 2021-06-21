-- 订单事实表

USE gmall;

DROP TABLE IF EXISTS dwd_order_info;
CREATE EXTERNAL TABLE dwd_order_info
(
    `id`                     STRING COMMENT '编号',
    `order_status`           STRING COMMENT '订单状态',
    `user_id`                STRING COMMENT '用户ID',
    `province_id`            STRING COMMENT '地区ID',
    `payment_way`            STRING COMMENT '支付方式',
    `delivery_address`       STRING COMMENT '邮寄地址',
    `out_trade_no`           STRING COMMENT '对外交易编号',
    `tracking_no`            STRING COMMENT '物流单号',
    `create_time`            STRING COMMENT '创建时间(未支付状态)',
    `payment_time`           STRING COMMENT '支付时间(已支付状态)',
    `cancel_time`            STRING COMMENT '取消时间(已取消状态)',
    `finish_time`            STRING COMMENT '完成时间(已完成状态)',
    `refund_time`            STRING COMMENT '退款时间(退款中状态)',
    `refund_finish_time`     STRING COMMENT '退款完成时间(退款完成状态)',
    `expire_time`            STRING COMMENT '过期时间',
    `feight_fee`             DECIMAL(16, 2) COMMENT '运费',
    `feight_fee_reduce`      DECIMAL(16, 2) COMMENT '运费减免',
    `activity_reduce_amount` DECIMAL(16, 2) COMMENT '活动减免',
    `coupon_reduce_amount`   DECIMAL(16, 2) COMMENT '优惠券减免',
    `original_amount`        DECIMAL(16, 2) COMMENT '订单原始价格',
    `final_amount`           DECIMAL(16, 2) COMMENT '订单最终价格'
) COMMENT '订单事实表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_order_info/'
    TBLPROPERTIES ("orc.compress" = "snappy");
