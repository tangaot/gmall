-- 用户行为漏斗分析

USE gmall;

with tmp_page as
         (
             select '2021-06-16'                                        dt,
                    sum(if(array_contains(pages, 'home'), 1, 0))        home_count,
                    sum(if(array_contains(pages, 'good_detail'), 1, 0)) good_detail_count
             from (
                      select mid_id,
                             collect_set(page.page_id) pages
                      from dws_visitor_action_daycount lateral view explode(page_stats) tmp as page
                      where dt = '2021-06-16'
                        and page.page_id in ('home', 'good_detail')
                      group by mid_id
                  ) t1
         ),
     tmp_cop as
         (
             select '2021-06-16'                             dt,
                    sum(if(cart_last_1d_count > 0, 1, 0))    cart_count,
                    sum(if(order_last_1d_count > 0, 1, 0))   order_count,
                    sum(if(payment_last_1d_count > 0, 1, 0)) payment_count
             from dwt_user_topic
             where dt = '2021-06-16'
         )
insert
overwrite
table
ads_user_action
select *
from ads_user_action
union
select tmp_page.dt,
       home_count,
       good_detail_count,
       cart_count,
       order_count,
       payment_count
from tmp_page
         join tmp_cop
              on tmp_page.dt = tmp_cop.dt;
