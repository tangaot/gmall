-- 活动主题

USE gmall;

DROP TABLE IF EXISTS dws_activity_info_daycount;
CREATE EXTERNAL TABLE dws_activity_info_daycount
(
    `activity_rule_id`      STRING COMMENT '活动规则ID',
    `activity_id`           STRING COMMENT '活动ID',
    `order_count`           BIGINT COMMENT '参与某活动某规则下单次数',--注意：针对的是某个活动的某个具体规则
    `order_reduce_amount`   DECIMAL(16, 2) COMMENT '参与某活动某规则下单减免金额',
    `order_original_amount` DECIMAL(16, 2) COMMENT '参与某活动某规则下单原始金额',--只统计参与活动的订单明细,未参与活动的订单明细不统计。
    `order_final_amount`    DECIMAL(16, 2) COMMENT '参与某活动某规则下单最终金额',
    `payment_count`         BIGINT COMMENT '参与某活动某规则支付次数',
    `payment_reduce_amount` DECIMAL(16, 2) COMMENT '参与某活动某规则支付减免金额',
    `payment_amount`        DECIMAL(16, 2) COMMENT '参与某活动某规则支付金额'
) COMMENT '每日活动统计'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dws/dws_activity_info_daycount/'
    TBLPROPERTIES ("orc.compress" = "snappy");

