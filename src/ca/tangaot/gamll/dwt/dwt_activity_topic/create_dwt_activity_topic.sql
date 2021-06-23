-- 活动主题

USE gmall;

DROP TABLE IF EXISTS dwt_activity_topic;
CREATE EXTERNAL TABLE dwt_activity_topic
(
    `activity_rule_id`              STRING COMMENT '活动规则ID',
    `activity_id`                   STRING COMMENT '活动ID',
    `order_last_1d_count`           BIGINT COMMENT '最近1日参与某活动某规则下单次数',
    `order_last_1d_reduce_amount`   DECIMAL(16, 2) COMMENT '最近1日参与某活动某规则下单优惠金额',
    `order_last_1d_original_amount` DECIMAL(16, 2) COMMENT '最近1日参与某活动某规则下单原始金额',
    `order_last_1d_final_amount`    DECIMAL(16, 2) COMMENT '最近1日参与某活动某规则下单最终金额',
    `order_count`                   BIGINT COMMENT '参与某活动某规则累积下单次数',
    `order_reduce_amount`           DECIMAL(16, 2) COMMENT '参与某活动某规则累积下单优惠金额',
    `order_original_amount`         DECIMAL(16, 2) COMMENT '参与某活动某规则累积下单原始金额',
    `order_final_amount`            DECIMAL(16, 2) COMMENT '参与某活动某规则累积下单最终金额',
    `payment_last_1d_count`         BIGINT COMMENT '最近1日参与某活动某规则支付次数',
    `payment_last_1d_reduce_amount` DECIMAL(16, 2) COMMENT '最近1日参与某活动某规则支付优惠金额',
    `payment_last_1d_amount`        DECIMAL(16, 2) COMMENT '最近1日参与某活动某规则支付金额',
    `payment_count`                 BIGINT COMMENT '参与某活动某规则累积支付次数',
    `payment_reduce_amount`         DECIMAL(16, 2) COMMENT '参与某活动某规则累积支付优惠金额',
    `payment_amount`                DECIMAL(16, 2) COMMENT '参与某活动某规则累积支付金额'
) COMMENT '活动主题宽表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwt/dwt_activity_topic/'
    TBLPROPERTIES ("orc.compress" = "snappy");
