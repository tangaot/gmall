USE gmall;

create function explode_json_array
    as 'com.atguigu.hive.udtf.ExplodeJSONArray'
    using jar 'hdfs://hadoop102:8020/user/hive/jars/hivefunction-1.0-SNAPSHOT.jar';