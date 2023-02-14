package com.kavalok.monitor.jdbc;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.DriverPropertyInfo;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.StringTokenizer;

import com.mysql.jdbc.ConnectionPropertiesTransform;
import com.mysql.jdbc.SQLError;
import com.mysql.jdbc.StringUtils;
import com.mysql.jdbc.Util;

public class Driver implements java.sql.Driver {

  private java.sql.Driver wrapper;

  static {
    try {
      DriverManager.registerDriver(new Driver());
    } catch (SQLException E) {
      throw new RuntimeException("Can't register driver!");
    }
  }

  @Override
  public boolean acceptsURL(String url) throws SQLException {
    // TODO Auto-generated method stub
    return parseURL(url, null) != null;
  }

  @Override
  public Connection connect(String url, Properties info) throws SQLException {
    String wrapperClassName = info.getProperty("wrapper_driver_class");
    Connection wrappedConnection = null;
    try {
      Class<?> wrapperClass = Class.forName(wrapperClassName);
      wrapper = (java.sql.Driver) wrapperClass.getConstructor().newInstance();
      wrappedConnection = wrapper.connect(url, info);
    } catch (ClassNotFoundException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    } catch (IllegalArgumentException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    } catch (SecurityException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    } catch (InstantiationException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    } catch (IllegalAccessException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    } catch (InvocationTargetException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    } catch (NoSuchMethodException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return new com.kavalok.monitor.jdbc.Connection(wrappedConnection);
  }

  @Override
  public int getMajorVersion() {
    // TODO Auto-generated method stub
    return wrapper.getMajorVersion();
  }

  @Override
  public int getMinorVersion() {
    // TODO Auto-generated method stub
    return wrapper.getMinorVersion();
  }

  @Override
  public DriverPropertyInfo[] getPropertyInfo(String arg0, Properties arg1) throws SQLException {
    // TODO Auto-generated method stub
    return wrapper.getPropertyInfo(arg0, arg1);
  }

  @Override
  public boolean jdbcCompliant() {
    // TODO Auto-generated method stub
    return wrapper.jdbcCompliant();
  }

  public Properties parseURL(String url, Properties defaults) throws SQLException {
    Properties urlProps = defaults == null ? new Properties() : new Properties(defaults);
    if (url == null)
      return null;
    if (!StringUtils.startsWithIgnoreCase(url, "jdbc:mysql://")
        && !StringUtils.startsWithIgnoreCase(url, "jdbc:mysql:mxj://")
        && !StringUtils.startsWithIgnoreCase(url, "jdbc:mysql:loadbalance://")
        && !StringUtils.startsWithIgnoreCase(url, "jdbc:mysql:replication://"))
      return null;
    int beginningOfSlashes = url.indexOf("//");
    if (StringUtils.startsWithIgnoreCase(url, "jdbc:mysql:mxj://"))
      urlProps.setProperty("socketFactory", "com.mysql.management.driverlaunched.ServerLauncherSocketFactory");
    int index = url.indexOf("?");
    if (index != -1) {
      String paramString = url.substring(index + 1, url.length());
      url = url.substring(0, index);
      StringTokenizer queryParams = new StringTokenizer(paramString, "&");
      do {
        if (!queryParams.hasMoreTokens())
          break;
        String parameterValuePair = queryParams.nextToken();
        int indexOfEquals = StringUtils.indexOfIgnoreCase(0, parameterValuePair, "=");
        String parameter = null;
        String value = null;
        if (indexOfEquals != -1) {
          parameter = parameterValuePair.substring(0, indexOfEquals);
          if (indexOfEquals + 1 < parameterValuePair.length())
            value = parameterValuePair.substring(indexOfEquals + 1);
        }
        if (value != null && value.length() > 0 && parameter != null && parameter.length() > 0)
          try {
            urlProps.put(parameter, URLDecoder.decode(value, "UTF-8"));
          } catch (UnsupportedEncodingException badEncoding) {
            urlProps.put(parameter, URLDecoder.decode(value));
          } catch (NoSuchMethodError nsme) {
            urlProps.put(parameter, URLDecoder.decode(value));
          }
      } while (true);
    }
    url = url.substring(beginningOfSlashes + 2);
    String hostStuff = null;
    int slashIndex = url.indexOf("/");
    if (slashIndex != -1) {
      hostStuff = url.substring(0, slashIndex);
      if (slashIndex + 1 < url.length())
        urlProps.put("DBNAME", url.substring(slashIndex + 1, url.length()));
    } else {
      hostStuff = url;
    }
    if (hostStuff != null && hostStuff.length() > 0)
      urlProps.put("HOST", hostStuff);
    String propertiesTransformClassName = urlProps.getProperty("propertiesTransform");
    if (propertiesTransformClassName != null)
      try {
        ConnectionPropertiesTransform propTransformer = (ConnectionPropertiesTransform) Class.forName(
            propertiesTransformClassName).newInstance();
        urlProps = propTransformer.transformProperties(urlProps);
      } catch (InstantiationException e) {
        throw SQLError.createSQLException("Unable to create properties transform instance '"
            + propertiesTransformClassName + "' due to underlying exception: " + e.toString(), "01S00");
      } catch (IllegalAccessException e) {
        throw SQLError.createSQLException("Unable to create properties transform instance '"
            + propertiesTransformClassName + "' due to underlying exception: " + e.toString(), "01S00");
      } catch (ClassNotFoundException e) {
        throw SQLError.createSQLException("Unable to create properties transform instance '"
            + propertiesTransformClassName + "' due to underlying exception: " + e.toString(), "01S00");
      }
    if (Util.isColdFusion() && urlProps.getProperty("autoConfigureForColdFusion", "true").equalsIgnoreCase("true")) {
      String configs = urlProps.getProperty("useConfigs");
      StringBuffer newConfigs = new StringBuffer();
      if (configs != null) {
        newConfigs.append(configs);
        newConfigs.append(",");
      }
      newConfigs.append("coldFusion");
      urlProps.setProperty("useConfigs", newConfigs.toString());
    }
    String configNames = null;
    if (defaults != null)
      configNames = defaults.getProperty("useConfigs");
    if (configNames == null)
      configNames = urlProps.getProperty("useConfigs");
    if (configNames != null) {
      List splitNames = StringUtils.split(configNames, ",", true);
      Properties configProps = new Properties();
      for (Iterator namesIter = splitNames.iterator(); namesIter.hasNext();) {
        String configName = (String) namesIter.next();
        try {
          java.io.InputStream configAsStream = getClass().getResourceAsStream("configs/" + configName + ".properties");
          if (configAsStream == null)
            throw SQLError.createSQLException("Can't find configuration template named '" + configName + "'", "01S00");
          configProps.load(configAsStream);
        } catch (IOException ioEx) {
          throw SQLError.createSQLException("Unable to load configuration template '" + configName
              + "' due to underlying IOException: " + ioEx, "01S00");
        }
      }

      String key;
      String property;
      for (Iterator propsIter = urlProps.keySet().iterator(); propsIter.hasNext(); configProps.setProperty(key,
          property)) {
        key = propsIter.next().toString();
        property = urlProps.getProperty(key);
      }

      urlProps = configProps;
    }
    if (defaults != null) {
      String key;
      String property;
      for (Iterator propsIter = defaults.keySet().iterator(); propsIter.hasNext(); urlProps.setProperty(key, property)) {
        key = propsIter.next().toString();
        property = defaults.getProperty(key);
      }

    }
    return urlProps;
  }

}
