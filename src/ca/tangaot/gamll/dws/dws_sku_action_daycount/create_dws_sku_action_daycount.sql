-- 商品主题

USE gmall;

DROP TABLE IF EXISTS dws_sku_action_daycount;
CREATE EXTERNAL TABLE dws_sku_action_daycount
(
    `sku_id`                       STRING COMMENT 'sku_id',
    `order_count`                  BIGINT COMMENT '被下单次数',
    `order_num`                    BIGINT COMMENT '被下单件数',
    `order_activity_count`         BIGINT COMMENT '参与活动被下单次数',
    `order_coupon_count`           BIGINT COMMENT '使用优惠券被下单次数',
    `order_activity_reduce_amount` DECIMAL(16, 2) COMMENT '优惠金额(活动)',
    `order_coupon_reduce_amount`   DECIMAL(16, 2) COMMENT '优惠金额(优惠券)',
    `order_original_amount`        DECIMAL(16, 2) COMMENT '被下单原价金额',
    `order_final_amount`           DECIMAL(16, 2) COMMENT '被下单最终金额',
    `payment_count`                BIGINT COMMENT '被支付次数',
    `payment_num`                  BIGINT COMMENT '被支付件数',
    `payment_amount`               DECIMAL(16, 2) COMMENT '被支付金额',
    `refund_order_count`           BIGINT COMMENT '被退单次数',
    `refund_order_num`             BIGINT COMMENT '被退单件数',
    `refund_order_amount`          DECIMAL(16, 2) COMMENT '被退单金额',
    `refund_payment_count`         BIGINT COMMENT '被退款次数',
    `refund_payment_num`           BIGINT COMMENT '被退款件数',
    `refund_payment_amount`        DECIMAL(16, 2) COMMENT '被退款金额',
    `cart_count`                   BIGINT COMMENT '被加入购物车次数',
    `favor_count`                  BIGINT COMMENT '被收藏次数',
    `appraise_good_count`          BIGINT COMMENT '好评数',
    `appraise_mid_count`           BIGINT COMMENT '中评数',
    `appraise_bad_count`           BIGINT COMMENT '差评数',
    `appraise_default_count`       BIGINT COMMENT '默认评价数'
) COMMENT '每日商品行为'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dws/dws_sku_action_daycount/'
    TBLPROPERTIES ("orc.compress" = "snappy");
