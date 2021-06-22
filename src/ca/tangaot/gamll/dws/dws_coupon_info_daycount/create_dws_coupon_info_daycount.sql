-- 优惠券主题

USE gmall;

DROP TABLE IF EXISTS dws_coupon_info_daycount;
CREATE EXTERNAL TABLE dws_coupon_info_daycount
(
    `coupon_id`             STRING COMMENT '优惠券ID',
    `get_count`             BIGINT COMMENT '领取次数',
    `order_count`           BIGINT COMMENT '使用(下单)次数',
    `order_reduce_amount`   DECIMAL(16, 2) COMMENT '使用某券的订单优惠金额',
    `order_original_amount` DECIMAL(16, 2) COMMENT '使用某券的订单原价金额',
    `order_final_amount`    DECIMAL(16, 2) COMMENT '使用某券的订单总价金额',
    `payment_count`         BIGINT COMMENT '使用(支付)次数',
    `payment_reduce_amount` DECIMAL(16, 2) COMMENT '使用某券的支付优惠金额',
    `payment_amount`        DECIMAL(16, 2) COMMENT '使用某券支付的总金额',
    `expire_count`          BIGINT COMMENT '过期次数'
) COMMENT '每日活动统计'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dws/dws_coupon_info_daycount/'
    TBLPROPERTIES ("orc.compress" = "snappy");


