-- 退款事实表

USE gmall;

DROP TABLE IF EXISTS dwd_refund_payment;
CREATE EXTERNAL TABLE dwd_refund_payment
(
    `id`            STRING COMMENT '编号',
    `user_id`       STRING COMMENT '用户ID',
    `order_id`      STRING COMMENT '订单编号',
    `sku_id`        STRING COMMENT 'SKU编号',
    `province_id`   STRING COMMENT '地区ID',
    `trade_no`      STRING COMMENT '交易编号',
    `out_trade_no`  STRING COMMENT '对外交易编号',
    `payment_type`  STRING COMMENT '支付类型',
    `refund_amount` DECIMAL(16, 2) COMMENT '退款金额',
    `refund_status` STRING COMMENT '退款状态',
    `create_time`   STRING COMMENT '创建时间',--调用第三方支付接口的时间
    `callback_time` STRING COMMENT '回调时间'--支付接口回调时间，即支付成功时间
) COMMENT '退款事实表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_refund_payment/'
    TBLPROPERTIES ("orc.compress" = "snappy");
