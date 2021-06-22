-- 地区主题

USE gmall;

DROP TABLE IF EXISTS dws_area_stats_daycount;
CREATE EXTERNAL TABLE dws_area_stats_daycount
(
    `province_id`           STRING COMMENT '地区编号',
    `visit_count`           BIGINT COMMENT '访客访问次数',
    `login_count`           BIGINT COMMENT '用户访问次数',
    `visitor_count`         BIGINT COMMENT '访客人数',
    `user_count`            BIGINT COMMENT '用户人数',
    `order_count`           BIGINT COMMENT '下单次数',
    `order_original_amount` DECIMAL(16, 2) COMMENT '下单原始金额',
    `order_final_amount`    DECIMAL(16, 2) COMMENT '下单最终金额',
    `payment_count`         BIGINT COMMENT '支付次数',
    `payment_amount`        DECIMAL(16, 2) COMMENT '支付金额',
    `refund_order_count`    BIGINT COMMENT '退单次数',
    `refund_order_amount`   DECIMAL(16, 2) COMMENT '退单金额',
    `refund_payment_count`  BIGINT COMMENT '退款次数',
    `refund_payment_amount` DECIMAL(16, 2) COMMENT '退款金额'
) COMMENT '每日地区统计表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dws/dws_area_stats_daycount/'
    TBLPROPERTIES ("orc.compress" = "snappy");

