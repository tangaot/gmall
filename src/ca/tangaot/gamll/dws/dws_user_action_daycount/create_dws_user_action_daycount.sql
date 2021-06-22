-- 用户主题

USE gmall;

DROP TABLE IF EXISTS dws_user_action_daycount;
CREATE EXTERNAL TABLE dws_user_action_daycount
(
    `user_id`                      STRING COMMENT '用户id',
    `login_count`                  BIGINT COMMENT '登录次数',
    `cart_count`                   BIGINT COMMENT '加入购物车次数',
    `favor_count`                  BIGINT COMMENT '收藏次数',
    `order_count`                  BIGINT COMMENT '下单次数',
    `order_activity_count`         BIGINT COMMENT '订单参与活动次数',
    `order_activity_reduce_amount` DECIMAL(16, 2) COMMENT '订单减免金额(活动)',
    `order_coupon_count`           BIGINT COMMENT '订单用券次数',
    `order_coupon_reduce_amount`   DECIMAL(16, 2) COMMENT '订单减免金额(优惠券)',
    `order_original_amount`        DECIMAL(16, 2) COMMENT '订单单原始金额',
    `order_final_amount`           DECIMAL(16, 2) COMMENT '订单总金额',
    `payment_count`                BIGINT COMMENT '支付次数',
    `payment_amount`               DECIMAL(16, 2) COMMENT '支付金额',
    `refund_order_count`           BIGINT COMMENT '退单次数',
    `refund_order_num`             BIGINT COMMENT '退单件数',
    `refund_order_amount`          DECIMAL(16, 2) COMMENT '退单金额',
    `refund_payment_count`         BIGINT COMMENT '退款次数',
    `refund_payment_num`           BIGINT COMMENT '退款件数',
    `refund_payment_amount`        DECIMAL(16, 2) COMMENT '退款金额',
    `coupon_get_count`             BIGINT COMMENT '优惠券领取次数',
    `coupon_using_count`           BIGINT COMMENT '优惠券使用(下单)次数',
    `coupon_used_count`            BIGINT COMMENT '优惠券使用(支付)次数',
    `appraise_good_count`          BIGINT COMMENT '好评数',
    `appraise_mid_count`           BIGINT COMMENT '中评数',
    `appraise_bad_count`           BIGINT COMMENT '差评数',
    `appraise_default_count`       BIGINT COMMENT '默认评价数',
    `order_detail_stats`           array<struct<sku_id :string,sku_num :bigint,order_count :bigint,activity_reduce_amount
                                                :decimal(16, 2),coupon_reduce_amount :decimal(16, 2),original_amount
                                                :decimal(16, 2),final_amount :decimal(16, 2)>> COMMENT '下单明细统计'
) COMMENT '每日用户行为'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dws/dws_user_action_daycount/'
    TBLPROPERTIES ("orc.compress" = "snappy");
