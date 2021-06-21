-- 优惠券领用事实表

USE gmall;

DROP TABLE IF EXISTS dwd_coupon_use;
CREATE EXTERNAL TABLE dwd_coupon_use
(
    `id`            STRING COMMENT '编号',
    `coupon_id`     STRING COMMENT '优惠券ID',
    `user_id`       STRING COMMENT 'userid',
    `order_id`      STRING COMMENT '订单id',
    `coupon_status` STRING COMMENT '优惠券状态',
    `get_time`      STRING COMMENT '领取时间',
    `using_time`    STRING COMMENT '使用时间(下单)',
    `used_time`     STRING COMMENT '使用时间(支付)',
    `expire_time`   STRING COMMENT '过期时间'
) COMMENT '优惠券领用事实表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_coupon_use/'
    TBLPROPERTIES ("orc.compress" = "snappy");
