-- 地区主题

USE gmall;

DROP TABLE IF EXISTS dwt_area_topic;
CREATE EXTERNAL TABLE dwt_area_topic
(
    `province_id`                    STRING COMMENT '编号',
    `visit_last_1d_count`            BIGINT COMMENT '最近1日访客访问次数',
    `login_last_1d_count`            BIGINT COMMENT '最近1日用户访问次数',
    `visit_last_7d_count`            BIGINT COMMENT '最近7访客访问次数',
    `login_last_7d_count`            BIGINT COMMENT '最近7日用户访问次数',
    `visit_last_30d_count`           BIGINT COMMENT '最近30日访客访问次数',
    `login_last_30d_count`           BIGINT COMMENT '最近30日用户访问次数',
    `visit_count`                    BIGINT COMMENT '累积访客访问次数',
    `login_count`                    BIGINT COMMENT '累积用户访问次数',
    `order_last_1d_count`            BIGINT COMMENT '最近1天下单次数',
    `order_last_1d_original_amount`  DECIMAL(16, 2) COMMENT '最近1天下单原始金额',
    `order_last_1d_final_amount`     DECIMAL(16, 2) COMMENT '最近1天下单最终金额',
    `order_last_7d_count`            BIGINT COMMENT '最近7天下单次数',
    `order_last_7d_original_amount`  DECIMAL(16, 2) COMMENT '最近7天下单原始金额',
    `order_last_7d_final_amount`     DECIMAL(16, 2) COMMENT '最近7天下单最终金额',
    `order_last_30d_count`           BIGINT COMMENT '最近30天下单次数',
    `order_last_30d_original_amount` DECIMAL(16, 2) COMMENT '最近30天下单原始金额',
    `order_last_30d_final_amount`    DECIMAL(16, 2) COMMENT '最近30天下单最终金额',
    `order_count`                    BIGINT COMMENT '累积下单次数',
    `order_original_amount`          DECIMAL(16, 2) COMMENT '累积下单原始金额',
    `order_final_amount`             DECIMAL(16, 2) COMMENT '累积下单最终金额',
    `payment_last_1d_count`          BIGINT COMMENT '最近1天支付次数',
    `payment_last_1d_amount`         DECIMAL(16, 2) COMMENT '最近1天支付金额',
    `payment_last_7d_count`          BIGINT COMMENT '最近7天支付次数',
    `payment_last_7d_amount`         DECIMAL(16, 2) COMMENT '最近7天支付金额',
    `payment_last_30d_count`         BIGINT COMMENT '最近30天支付次数',
    `payment_last_30d_amount`        DECIMAL(16, 2) COMMENT '最近30天支付金额',
    `payment_count`                  BIGINT COMMENT '累积支付次数',
    `payment_amount`                 DECIMAL(16, 2) COMMENT '累积支付金额',
    `refund_order_last_1d_count`     BIGINT COMMENT '最近1天退单次数',
    `refund_order_last_1d_amount`    DECIMAL(16, 2) COMMENT '最近1天退单金额',
    `refund_order_last_7d_count`     BIGINT COMMENT '最近7天退单次数',
    `refund_order_last_7d_amount`    DECIMAL(16, 2) COMMENT '最近7天退单金额',
    `refund_order_last_30d_count`    BIGINT COMMENT '最近30天退单次数',
    `refund_order_last_30d_amount`   DECIMAL(16, 2) COMMENT '最近30天退单金额',
    `refund_order_count`             BIGINT COMMENT '累积退单次数',
    `refund_order_amount`            DECIMAL(16, 2) COMMENT '累积退单金额',
    `refund_payment_last_1d_count`   BIGINT COMMENT '最近1天退款次数',
    `refund_payment_last_1d_amount`  DECIMAL(16, 2) COMMENT '最近1天退款金额',
    `refund_payment_last_7d_count`   BIGINT COMMENT '最近7天退款次数',
    `refund_payment_last_7d_amount`  DECIMAL(16, 2) COMMENT '最近7天退款金额',
    `refund_payment_last_30d_count`  BIGINT COMMENT '最近30天退款次数',
    `refund_payment_last_30d_amount` DECIMAL(16, 2) COMMENT '最近30天退款金额',
    `refund_payment_count`           BIGINT COMMENT '累积退款次数',
    `refund_payment_amount`          DECIMAL(16, 2) COMMENT '累积退款金额'
) COMMENT '地区主题宽表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwt/dwt_area_topic/'
    TBLPROPERTIES ("orc.compress" = "snappy");
