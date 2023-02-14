package com.kavalok.monitor.jdbc;

import java.io.InputStream;
import java.io.Reader;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.Array;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.Date;
import java.sql.NClob;
import java.sql.ParameterMetaData;
import java.sql.Ref;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.RowId;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.SQLXML;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Calendar;

import org.red5.threadmonitoring.ThreadMonitorServices;

public class PreparedStatement implements java.sql.PreparedStatement {
  private java.sql.PreparedStatement wrapper;

  private String sSql;

  public PreparedStatement(String sql, java.sql.PreparedStatement wrapperStatement) {
    this.wrapper = wrapperStatement;
    this.sSql = sql;
  }

  public void addBatch() throws SQLException {
    wrapper.addBatch();
  }

  public void addBatch(String sql) throws SQLException {
    wrapper.addBatch(sql);
  }

  public void cancel() throws SQLException {
    wrapper.cancel();
  }

  public void clearBatch() throws SQLException {
    wrapper.clearBatch();
  }

  public void clearParameters() throws SQLException {
    wrapper.clearParameters();
  }

  public void clearWarnings() throws SQLException {
    wrapper.clearWarnings();
  }

  public void close() throws SQLException {
    wrapper.close();
  }

  public boolean execute() throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute() {0}", sSql);
    return wrapper.execute();
  }

  public boolean execute(String sql, int autoGeneratedKeys) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute(String sql {0}, int autoGeneratedKeys {1})", sql,
        autoGeneratedKeys);
    return wrapper.execute(sql, autoGeneratedKeys);
  }

  public boolean execute(String sql, int[] columnIndexes) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute(String sql {0}, int columnIndexes {1})", sql,
        columnIndexes);
    return wrapper.execute(sql, columnIndexes);
  }

  public boolean execute(String sql, String[] columnNames) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute(String sql {0}, int columnNames {1})", sql,
        columnNames);
    return wrapper.execute(sql, columnNames);
  }

  public boolean execute(String sql) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute(String sql {0})", sql);
    return wrapper.execute(sql);
  }

  public int[] executeBatch() throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.executeBatch() {0}", sSql);
    return wrapper.executeBatch();
  }

  public ResultSet executeQuery() throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.executeQuery() {0}", sSql);
    return wrapper.executeQuery();
  }

  public ResultSet executeQuery(String sql) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.executeQuery(String sql {0})", sql);
    return wrapper.executeQuery(sql);
  }

  public int executeUpdate() throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.executeUpdate() {0}", sSql);
    return wrapper.executeUpdate();
  }

  public int executeUpdate(String sql, int autoGeneratedKeys) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute(String sql {0}, int autoGeneratedKeys {1})", sql,
        autoGeneratedKeys);
    return wrapper.executeUpdate(sql, autoGeneratedKeys);
  }

  public int executeUpdate(String sql, int[] columnIndexes) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute(String sql {0}, int columnIndexes {1})", sql,
        columnIndexes);
    return wrapper.executeUpdate(sql, columnIndexes);
  }

  public int executeUpdate(String sql, String[] columnNames) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute(String sql {0}, int columnNames {1})", sql,
        columnNames);
    return wrapper.executeUpdate(sql, columnNames);
  }

  public int executeUpdate(String sql) throws SQLException {
    ThreadMonitorServices.setJobDetails("PreparedStatement.execute(String sql {0})", sql);
    return wrapper.executeUpdate(sql);
  }

  public Connection getConnection() throws SQLException {
    return wrapper.getConnection();
  }

  public int getFetchDirection() throws SQLException {
    return wrapper.getFetchDirection();
  }

  public int getFetchSize() throws SQLException {
    return wrapper.getFetchSize();
  }

  public ResultSet getGeneratedKeys() throws SQLException {
    return wrapper.getGeneratedKeys();
  }

  public int getMaxFieldSize() throws SQLException {
    return wrapper.getMaxFieldSize();
  }

  public int getMaxRows() throws SQLException {
    return wrapper.getMaxRows();
  }

  public ResultSetMetaData getMetaData() throws SQLException {
    return wrapper.getMetaData();
  }

  public boolean getMoreResults() throws SQLException {
    return wrapper.getMoreResults();
  }

  public boolean getMoreResults(int current) throws SQLException {
    return wrapper.getMoreResults(current);
  }

  public ParameterMetaData getParameterMetaData() throws SQLException {
    return wrapper.getParameterMetaData();
  }

  public int getQueryTimeout() throws SQLException {
    return wrapper.getQueryTimeout();
  }

  public ResultSet getResultSet() throws SQLException {
    return wrapper.getResultSet();
  }

  public int getResultSetConcurrency() throws SQLException {
    return wrapper.getResultSetConcurrency();
  }

  public int getResultSetHoldability() throws SQLException {
    return wrapper.getResultSetHoldability();
  }

  public int getResultSetType() throws SQLException {
    return wrapper.getResultSetType();
  }

  public int getUpdateCount() throws SQLException {
    return wrapper.getUpdateCount();
  }

  public SQLWarning getWarnings() throws SQLException {
    return wrapper.getWarnings();
  }

  public boolean isClosed() throws SQLException {
    return wrapper.isClosed();
  }

  public boolean isPoolable() throws SQLException {
    return wrapper.isPoolable();
  }

  public boolean isWrapperFor(Class<?> iface) throws SQLException {
    return wrapper.isWrapperFor(iface);
  }

  public void setArray(int parameterIndex, Array x) throws SQLException {
    wrapper.setArray(parameterIndex, x);
  }

  public void setAsciiStream(int parameterIndex, InputStream x, int length) throws SQLException {
    wrapper.setAsciiStream(parameterIndex, x, length);
  }

  public void setAsciiStream(int parameterIndex, InputStream x, long length) throws SQLException {
    wrapper.setAsciiStream(parameterIndex, x, length);
  }

  public void setAsciiStream(int parameterIndex, InputStream x) throws SQLException {
    wrapper.setAsciiStream(parameterIndex, x);
  }

  public void setBigDecimal(int parameterIndex, BigDecimal x) throws SQLException {
    wrapper.setBigDecimal(parameterIndex, x);
  }

  public void setBinaryStream(int parameterIndex, InputStream x, int length) throws SQLException {
    wrapper.setBinaryStream(parameterIndex, x, length);
  }

  public void setBinaryStream(int parameterIndex, InputStream x, long length) throws SQLException {
    wrapper.setBinaryStream(parameterIndex, x, length);
  }

  public void setBinaryStream(int parameterIndex, InputStream x) throws SQLException {
    wrapper.setBinaryStream(parameterIndex, x);
  }

  public void setBlob(int parameterIndex, Blob x) throws SQLException {
    wrapper.setBlob(parameterIndex, x);
  }

  public void setBlob(int parameterIndex, InputStream inputStream, long length) throws SQLException {
    wrapper.setBlob(parameterIndex, inputStream, length);
  }

  public void setBlob(int parameterIndex, InputStream inputStream) throws SQLException {
    wrapper.setBlob(parameterIndex, inputStream);
  }

  public void setBoolean(int parameterIndex, boolean x) throws SQLException {
    wrapper.setBoolean(parameterIndex, x);
  }

  public void setByte(int parameterIndex, byte x) throws SQLException {
    wrapper.setByte(parameterIndex, x);
  }

  public void setBytes(int parameterIndex, byte[] x) throws SQLException {
    wrapper.setBytes(parameterIndex, x);
  }

  public void setCharacterStream(int parameterIndex, Reader reader, int length) throws SQLException {
    wrapper.setCharacterStream(parameterIndex, reader, length);
  }

  public void setCharacterStream(int parameterIndex, Reader reader, long length) throws SQLException {
    wrapper.setCharacterStream(parameterIndex, reader, length);
  }

  public void setCharacterStream(int parameterIndex, Reader reader) throws SQLException {
    wrapper.setCharacterStream(parameterIndex, reader);
  }

  public void setClob(int parameterIndex, Clob x) throws SQLException {
    wrapper.setClob(parameterIndex, x);
  }

  public void setClob(int parameterIndex, Reader reader, long length) throws SQLException {
    wrapper.setClob(parameterIndex, reader, length);
  }

  public void setClob(int parameterIndex, Reader reader) throws SQLException {
    wrapper.setClob(parameterIndex, reader);
  }

  public void setCursorName(String name) throws SQLException {
    wrapper.setCursorName(name);
  }

  public void setDate(int parameterIndex, Date x, Calendar cal) throws SQLException {
    wrapper.setDate(parameterIndex, x, cal);
  }

  public void setDate(int parameterIndex, Date x) throws SQLException {
    wrapper.setDate(parameterIndex, x);
  }

  public void setDouble(int parameterIndex, double x) throws SQLException {
    wrapper.setDouble(parameterIndex, x);
  }

  public void setEscapeProcessing(boolean enable) throws SQLException {
    wrapper.setEscapeProcessing(enable);
  }

  public void setFetchDirection(int direction) throws SQLException {
    wrapper.setFetchDirection(direction);
  }

  public void setFetchSize(int rows) throws SQLException {
    wrapper.setFetchSize(rows);
  }

  public void setFloat(int parameterIndex, float x) throws SQLException {
    wrapper.setFloat(parameterIndex, x);
  }

  public void setInt(int parameterIndex, int x) throws SQLException {
    wrapper.setInt(parameterIndex, x);
  }

  public void setLong(int parameterIndex, long x) throws SQLException {
    wrapper.setLong(parameterIndex, x);
  }

  public void setMaxFieldSize(int max) throws SQLException {
    wrapper.setMaxFieldSize(max);
  }

  public void setMaxRows(int max) throws SQLException {
    wrapper.setMaxRows(max);
  }

  public void setNCharacterStream(int parameterIndex, Reader value, long length) throws SQLException {
    wrapper.setNCharacterStream(parameterIndex, value, length);
  }

  public void setNCharacterStream(int parameterIndex, Reader value) throws SQLException {
    wrapper.setNCharacterStream(parameterIndex, value);
  }

  public void setNClob(int parameterIndex, NClob value) throws SQLException {
    wrapper.setNClob(parameterIndex, value);
  }

  public void setNClob(int parameterIndex, Reader reader, long length) throws SQLException {
    wrapper.setNClob(parameterIndex, reader, length);
  }

  public void setNClob(int parameterIndex, Reader reader) throws SQLException {
    wrapper.setNClob(parameterIndex, reader);
  }

  public void setNString(int parameterIndex, String value) throws SQLException {
    wrapper.setNString(parameterIndex, value);
  }

  public void setNull(int parameterIndex, int sqlType, String typeName) throws SQLException {
    wrapper.setNull(parameterIndex, sqlType, typeName);
  }

  public void setNull(int parameterIndex, int sqlType) throws SQLException {
    wrapper.setNull(parameterIndex, sqlType);
  }

  public void setObject(int parameterIndex, Object x, int targetSqlType, int scaleOrLength) throws SQLException {
    wrapper.setObject(parameterIndex, x, targetSqlType, scaleOrLength);
  }

  public void setObject(int parameterIndex, Object x, int targetSqlType) throws SQLException {
    wrapper.setObject(parameterIndex, x, targetSqlType);
  }

  public void setObject(int parameterIndex, Object x) throws SQLException {
    wrapper.setObject(parameterIndex, x);
  }

  public void setPoolable(boolean poolable) throws SQLException {
    wrapper.setPoolable(poolable);
  }

  public void setQueryTimeout(int seconds) throws SQLException {
    wrapper.setQueryTimeout(seconds);
  }

  public void setRef(int parameterIndex, Ref x) throws SQLException {
    wrapper.setRef(parameterIndex, x);
  }

  public void setRowId(int parameterIndex, RowId x) throws SQLException {
    wrapper.setRowId(parameterIndex, x);
  }

  public void setShort(int parameterIndex, short x) throws SQLException {
    wrapper.setShort(parameterIndex, x);
  }

  public void setSQLXML(int parameterIndex, SQLXML xmlObject) throws SQLException {
    wrapper.setSQLXML(parameterIndex, xmlObject);
  }

  public void setString(int parameterIndex, String x) throws SQLException {
    wrapper.setString(parameterIndex, x);
  }

  public void setTime(int parameterIndex, Time x, Calendar cal) throws SQLException {
    wrapper.setTime(parameterIndex, x, cal);
  }

  public void setTime(int parameterIndex, Time x) throws SQLException {
    wrapper.setTime(parameterIndex, x);
  }

  public void setTimestamp(int parameterIndex, Timestamp x, Calendar cal) throws SQLException {
    wrapper.setTimestamp(parameterIndex, x, cal);
  }

  public void setTimestamp(int parameterIndex, Timestamp x) throws SQLException {
    wrapper.setTimestamp(parameterIndex, x);
  }

  @Deprecated
  public void setUnicodeStream(int parameterIndex, InputStream x, int length) throws SQLException {
    wrapper.setUnicodeStream(parameterIndex, x, length);
  }

  public void setURL(int parameterIndex, URL x) throws SQLException {
    wrapper.setURL(parameterIndex, x);
  }

  public <T> T unwrap(Class<T> iface) throws SQLException {
    return wrapper.unwrap(iface);
  }

}
