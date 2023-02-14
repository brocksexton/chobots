/*
 * Created on 13/1/2004
 *  
 */
package org.red5.threadmonitoring;

import java.util.Locale;

/**
 * It is proxy class that helps using
 * {@link java.text.MessageFormat java.text.MessageFormat }class. Methods of
 * the class just delegates calls to
 * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) format(java.lang.String, java.lang.Object[]) }
 * method not building object array, but just passing variables as parameters.
 * You can use up to 5 variables formatting your messages.
 *  
 */
public class MessageFormat extends java.text.MessageFormat {

  /**
   * @see java.text.MessageFormat#MessageFormat(java.lang.String).
   */
  public MessageFormat(String pattern, Locale locale) {
    super(pattern, locale);
  }

  /**
   * @see java.text.MessageFormat#MessageFormat(java.lang.String,
   *      java.util.Locale).
   */
  protected MessageFormat(String pattern) {
    super(pattern);
  }

  /**
   * Calls
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) format(java.lang.String, java.lang.Object[]) }
   * method building an object array containing the only element <code>arg1<code>.
   * @see java.text.MessageFormat#format(java.lang.String, java.lang.Object[])
   */
  public static String doFormat(String pattern, Object arg1) {
    return format(pattern, new Object[] { arg1 });
  }

  /**
   * @see java.text.MessageFormat#format(java.lang.String, java.lang.Object[])
   * @see MessageFormat#doFormat(String, Object)
   */
  public static String doFormat(String pattern, Object arg1, Object arg2) {
    return format(pattern, new Object[] { arg1, arg2 });
  }

  /**
   * @see java.text.MessageFormat#format(java.lang.String, java.lang.Object[])
   * @see MessageFormat#doFormat(String, Object)
   */
  public static String doFormat(String pattern, Object arg1, Object arg2, Object arg3) {
    return format(pattern, new Object[] { arg1, arg2, arg3 });
  }

  /**
   * @see java.text.MessageFormat#format(java.lang.String, java.lang.Object[])
   * @see MessageFormat#doFormat(String, Object)
   */
  public static String doFormat(String pattern, Object arg1, Object arg2, Object arg3, Object arg4) {
    return format(pattern, new Object[] { arg1, arg2, arg3, arg4 });
  }

  /**
   * @see java.text.MessageFormat#format(java.lang.String, java.lang.Object[])
   * @see MessageFormat#doFormat(String, Object)
   */
  public static String doFormat(String pattern, Object arg1, Object arg2, Object arg3, Object arg4, Object arg5) {
    return format(pattern, new Object[] { arg1, arg2, arg3, arg4, arg5 });
  }

}
