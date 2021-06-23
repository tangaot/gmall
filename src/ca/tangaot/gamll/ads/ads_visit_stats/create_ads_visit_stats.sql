-- 访客统计

USE gmall;

DROP TABLE IF EXISTS ads_visit_stats;
CREATE EXTERNAL TABLE ads_visit_stats
(
    `dt`               STRING COMMENT '统计日期',
    `is_new`           STRING COMMENT '新老标识,1:新,0:老',
    `channel`          STRING COMMENT '渠道',
    `uv_count`         BIGINT COMMENT '日活(访问人数)',
    `duration_sec`     BIGINT COMMENT '页面停留总时长',
    `avg_duration_sec` BIGINT COMMENT '一次会话，页面停留平均时长,单位为描述',
    `page_count`       BIGINT COMMENT '页面总浏览数',
    `avg_page_count`   BIGINT COMMENT '一次会话，页面平均浏览数',
    `sv_count`         BIGINT COMMENT '会话次数',
    `bounce_count`     BIGINT COMMENT '跳出数',
    `bounce_rate`      DECIMAL(16, 2) COMMENT '跳出率'
) COMMENT '访客统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_visit_stats/';
