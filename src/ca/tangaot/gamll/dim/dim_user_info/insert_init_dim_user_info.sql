-- 5.6 用户维度表 首日装载

USE gmall;

insert overwrite table dim_user_info partition (dt = '9999-99-99')
select id,
       login_name,
       nick_name,
       md5(name),
       md5(phone_num),
       md5(email),
       user_level,
       birthday,
       gender,
       create_time,
       operate_time,
       '2021-06-16',
       '9999-99-99'
from ods_user_info
where dt = '2021-06-16';

