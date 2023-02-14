/*
 * Created on 9/4/2004
 */
package org.red5.threadmonitoring;

/**
 * <code>ThreadMonitorException</code> is implementation of
 * <code>RuntimeExeception</code> and is thrown when unable to retrieve data
 * from specified <code>Job</code> (for example when job is not stoped yet).
 */
public class ThreadMonitorException extends RuntimeException {

  /**
   * Constructs a new <code>ThreadMonitorException</code> exception with
   * <code>null</code> as its detail message.
   */
  public ThreadMonitorException() {
    super();
  }

  /**
   * Constructs a new <code>ThreadMonitorException</code> exception with the
   * specified detail message.
   * 
   * @param message
   *          the detail message.
   */
  public ThreadMonitorException(String message) {
    super(message);
  }
}