-- 优惠券主题

USE gmall;

DROP TABLE IF EXISTS dwt_coupon_topic;
CREATE EXTERNAL TABLE dwt_coupon_topic
(
    `coupon_id`                      STRING COMMENT '优惠券ID',
    `get_last_1d_count`              BIGINT COMMENT '最近1日领取次数',
    `get_last_7d_count`              BIGINT COMMENT '最近7日领取次数',
    `get_last_30d_count`             BIGINT COMMENT '最近30日领取次数',
    `get_count`                      BIGINT COMMENT '累积领取次数',
    `order_last_1d_count`            BIGINT COMMENT '最近1日使用某券下单次数',
    `order_last_1d_reduce_amount`    DECIMAL(16, 2) COMMENT '最近1日使用某券下单优惠金额',
    `order_last_1d_original_amount`  DECIMAL(16, 2) COMMENT '最近1日使用某券下单原始金额',
    `order_last_1d_final_amount`     DECIMAL(16, 2) COMMENT '最近1日使用某券下单最终金额',
    `order_last_7d_count`            BIGINT COMMENT '最近7日使用某券下单次数',
    `order_last_7d_reduce_amount`    DECIMAL(16, 2) COMMENT '最近7日使用某券下单优惠金额',
    `order_last_7d_original_amount`  DECIMAL(16, 2) COMMENT '最近7日使用某券下单原始金额',
    `order_last_7d_final_amount`     DECIMAL(16, 2) COMMENT '最近7日使用某券下单最终金额',
    `order_last_30d_count`           BIGINT COMMENT '最近30日使用某券下单次数',
    `order_last_30d_reduce_amount`   DECIMAL(16, 2) COMMENT '最近30日使用某券下单优惠金额',
    `order_last_30d_original_amount` DECIMAL(16, 2) COMMENT '最近30日使用某券下单原始金额',
    `order_last_30d_final_amount`    DECIMAL(16, 2) COMMENT '最近30日使用某券下单最终金额',
    `order_count`                    BIGINT COMMENT '累积使用(下单)次数',
    `order_reduce_amount`            DECIMAL(16, 2) COMMENT '使用某券累积下单优惠金额',
    `order_original_amount`          DECIMAL(16, 2) COMMENT '使用某券累积下单原始金额',
    `order_final_amount`             DECIMAL(16, 2) COMMENT '使用某券累积下单最终金额',
    `payment_last_1d_count`          BIGINT COMMENT '最近1日使用某券支付次数',
    `payment_last_1d_reduce_amount`  DECIMAL(16, 2) COMMENT '最近1日使用某券优惠金额',
    `payment_last_1d_amount`         DECIMAL(16, 2) COMMENT '最近1日使用某券支付金额',
    `payment_last_7d_count`          BIGINT COMMENT '最近7日使用某券支付次数',
    `payment_last_7d_reduce_amount`  DECIMAL(16, 2) COMMENT '最近7日使用某券优惠金额',
    `payment_last_7d_amount`         DECIMAL(16, 2) COMMENT '最近7日使用某券支付金额',
    `payment_last_30d_count`         BIGINT COMMENT '最近30日使用某券支付次数',
    `payment_last_30d_reduce_amount` DECIMAL(16, 2) COMMENT '最近30日使用某券优惠金额',
    `payment_last_30d_amount`        DECIMAL(16, 2) COMMENT '最近30日使用某券支付金额',
    `payment_count`                  BIGINT COMMENT '累积使用(支付)次数',
    `payment_reduce_amount`          DECIMAL(16, 2) COMMENT '使用某券累积优惠金额',
    `payment_amount`                 DECIMAL(16, 2) COMMENT '使用某券累积支付金额',
    `expire_last_1d_count`           BIGINT COMMENT '最近1日过期次数',
    `expire_last_7d_count`           BIGINT COMMENT '最近7日过期次数',
    `expire_last_30d_count`          BIGINT COMMENT '最近30日过期次数',
    `expire_count`                   BIGINT COMMENT '累积过期次数'
) comment '优惠券主题表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwt/dwt_coupon_topic/'
    TBLPROPERTIES ("orc.compress" = "snappy");
