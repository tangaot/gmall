// ORM class for table 'ads_user_online_count_min'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Fri Jun 25 19:01:50 CST 2021
// For connector: org.apache.sqoop.manager.MySQLManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import com.cloudera.sqoop.lib.JdbcWritableBridge;
import com.cloudera.sqoop.lib.DelimiterSet;
import com.cloudera.sqoop.lib.FieldFormatter;
import com.cloudera.sqoop.lib.RecordParser;
import com.cloudera.sqoop.lib.BooleanParser;
import com.cloudera.sqoop.lib.BlobRef;
import com.cloudera.sqoop.lib.ClobRef;
import com.cloudera.sqoop.lib.LargeObjectLoader;
import com.cloudera.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class ads_user_online_count_min extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  protected ResultSet __cur_result_set;
  private java.sql.Date dt;
  public java.sql.Date get_dt() {
    return dt;
  }
  public void set_dt(java.sql.Date dt) {
    this.dt = dt;
  }
  public ads_user_online_count_min with_dt(java.sql.Date dt) {
    this.dt = dt;
    return this;
  }
  private String mins;
  public String get_mins() {
    return mins;
  }
  public void set_mins(String mins) {
    this.mins = mins;
  }
  public ads_user_online_count_min with_mins(String mins) {
    this.mins = mins;
    return this;
  }
  private Long user_online_count;
  public Long get_user_online_count() {
    return user_online_count;
  }
  public void set_user_online_count(Long user_online_count) {
    this.user_online_count = user_online_count;
  }
  public ads_user_online_count_min with_user_online_count(Long user_online_count) {
    this.user_online_count = user_online_count;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof ads_user_online_count_min)) {
      return false;
    }
    ads_user_online_count_min that = (ads_user_online_count_min) o;
    boolean equal = true;
    equal = equal && (this.dt == null ? that.dt == null : this.dt.equals(that.dt));
    equal = equal && (this.mins == null ? that.mins == null : this.mins.equals(that.mins));
    equal = equal && (this.user_online_count == null ? that.user_online_count == null : this.user_online_count.equals(that.user_online_count));
    return equal;
  }
  public boolean equals0(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof ads_user_online_count_min)) {
      return false;
    }
    ads_user_online_count_min that = (ads_user_online_count_min) o;
    boolean equal = true;
    equal = equal && (this.dt == null ? that.dt == null : this.dt.equals(that.dt));
    equal = equal && (this.mins == null ? that.mins == null : this.mins.equals(that.mins));
    equal = equal && (this.user_online_count == null ? that.user_online_count == null : this.user_online_count.equals(that.user_online_count));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.dt = JdbcWritableBridge.readDate(1, __dbResults);
    this.mins = JdbcWritableBridge.readString(2, __dbResults);
    this.user_online_count = JdbcWritableBridge.readLong(3, __dbResults);
  }
  public void readFields0(ResultSet __dbResults) throws SQLException {
    this.dt = JdbcWritableBridge.readDate(1, __dbResults);
    this.mins = JdbcWritableBridge.readString(2, __dbResults);
    this.user_online_count = JdbcWritableBridge.readLong(3, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void loadLargeObjects0(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeDate(dt, 1 + __off, 91, __dbStmt);
    JdbcWritableBridge.writeString(mins, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeLong(user_online_count, 3 + __off, -5, __dbStmt);
    return 3;
  }
  public void write0(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeDate(dt, 1 + __off, 91, __dbStmt);
    JdbcWritableBridge.writeString(mins, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeLong(user_online_count, 3 + __off, -5, __dbStmt);
  }
  public void readFields(DataInput __dataIn) throws IOException {
this.readFields0(__dataIn);  }
  public void readFields0(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.dt = null;
    } else {
    this.dt = new Date(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.mins = null;
    } else {
    this.mins = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.user_online_count = null;
    } else {
    this.user_online_count = Long.valueOf(__dataIn.readLong());
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.dt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.dt.getTime());
    }
    if (null == this.mins) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, mins);
    }
    if (null == this.user_online_count) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.user_online_count);
    }
  }
  public void write0(DataOutput __dataOut) throws IOException {
    if (null == this.dt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.dt.getTime());
    }
    if (null == this.mins) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, mins);
    }
    if (null == this.user_online_count) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.user_online_count);
    }
  }
  private static final DelimiterSet __outputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    __sb.append(FieldFormatter.escapeAndEnclose(dt==null?"null":"" + dt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(mins==null?"null":mins, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(user_online_count==null?"null":"" + user_online_count, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  public void toString0(DelimiterSet delimiters, StringBuilder __sb, char fieldDelim) {
    __sb.append(FieldFormatter.escapeAndEnclose(dt==null?"null":"" + dt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(mins==null?"null":mins, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(user_online_count==null?"null":"" + user_online_count, delimiters));
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 9, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("\\N") || __cur_str.length() == 0) { this.dt = null; } else {
      this.dt = java.sql.Date.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("\\N")) { this.mins = null; } else {
      this.mins = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("\\N") || __cur_str.length() == 0) { this.user_online_count = null; } else {
      this.user_online_count = Long.valueOf(__cur_str);
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  private void __loadFromFields0(Iterator<String> __it) {
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("\\N") || __cur_str.length() == 0) { this.dt = null; } else {
      this.dt = java.sql.Date.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("\\N")) { this.mins = null; } else {
      this.mins = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("\\N") || __cur_str.length() == 0) { this.user_online_count = null; } else {
      this.user_online_count = Long.valueOf(__cur_str);
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    ads_user_online_count_min o = (ads_user_online_count_min) super.clone();
    o.dt = (o.dt != null) ? (java.sql.Date) o.dt.clone() : null;
    return o;
  }

  public void clone0(ads_user_online_count_min o) throws CloneNotSupportedException {
    o.dt = (o.dt != null) ? (java.sql.Date) o.dt.clone() : null;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("dt", this.dt);
    __sqoop$field_map.put("mins", this.mins);
    __sqoop$field_map.put("user_online_count", this.user_online_count);
    return __sqoop$field_map;
  }

  public void getFieldMap0(Map<String, Object> __sqoop$field_map) {
    __sqoop$field_map.put("dt", this.dt);
    __sqoop$field_map.put("mins", this.mins);
    __sqoop$field_map.put("user_online_count", this.user_online_count);
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("dt".equals(__fieldName)) {
      this.dt = (java.sql.Date) __fieldVal;
    }
    else    if ("mins".equals(__fieldName)) {
      this.mins = (String) __fieldVal;
    }
    else    if ("user_online_count".equals(__fieldName)) {
      this.user_online_count = (Long) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
  public boolean setField0(String __fieldName, Object __fieldVal) {
    if ("dt".equals(__fieldName)) {
      this.dt = (java.sql.Date) __fieldVal;
      return true;
    }
    else    if ("mins".equals(__fieldName)) {
      this.mins = (String) __fieldVal;
      return true;
    }
    else    if ("user_online_count".equals(__fieldName)) {
      this.user_online_count = (Long) __fieldVal;
      return true;
    }
    else {
      return false;    }
  }
}
