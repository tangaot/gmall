-- 支付事实表

USE gmall;

DROP TABLE IF EXISTS dwd_payment_info;
CREATE EXTERNAL TABLE dwd_payment_info
(
    `id`             STRING COMMENT '编号',
    `order_id`       STRING COMMENT '订单编号',
    `user_id`        STRING COMMENT '用户编号',
    `province_id`    STRING COMMENT '地区ID',
    `trade_no`       STRING COMMENT '交易编号',
    `out_trade_no`   STRING COMMENT '对外交易编号',
    `payment_type`   STRING COMMENT '支付类型',
    `payment_amount` DECIMAL(16, 2) COMMENT '支付金额',
    `payment_status` STRING COMMENT '支付状态',
    `create_time`    STRING COMMENT '创建时间',--调用第三方支付接口的时间
    `callback_time`  STRING COMMENT '完成时间'--支付完成时间，即支付成功回调时间
) COMMENT '支付事实表表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_payment_info/'
    TBLPROPERTIES ("orc.compress" = "snappy");
