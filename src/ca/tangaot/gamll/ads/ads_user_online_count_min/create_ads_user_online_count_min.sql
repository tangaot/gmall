-- 每分钟在线用户数

USE gmall;

DROP TABLE IF EXISTS ads_user_online_count_min;
CREATE EXTERNAL TABLE ads_user_online_count_min
(
    `dt`                STRING COMMENT '统计日期',
    `mins`              STRING COMMENT '分钟，要求格式为yyyy-MM-dd HH:mm',
    `user_online_count` BIGINT COMMENT ''
) COMMENT '每分钟在线用户数'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_user_online_count_min/';
