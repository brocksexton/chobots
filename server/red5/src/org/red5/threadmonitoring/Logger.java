/*
 * Created on 29-sep-2003
 *  
 */
package org.red5.threadmonitoring;

import java.text.MessageFormat;
import java.util.logging.Level;
import java.util.logging.LogManager;

public class Logger extends java.util.logging.Logger {

  /**
   * Constructs a Logger with the specified name. Registers the newly created
   * Logger with <code>@link java.util.logging.LogManager</code>.
   * 
   * @param name
   *          A name of the logger. It should be a dot-separated name; it should
   *          be normally based on the package name or class name of the
   *          subsystem, such as java.net or javax.swing. It may be null for
   *          anonymous Loggers.
   */
  public Logger(String name) {
    super(name, null);
    LogManager manager = LogManager.getLogManager();
    manager.addLogger(this);
  }

  /**
   * Formats and logs message with logging level <tt>INFO</tt>
   * 
   * @param infoMessage
   *          a message to log
   * @param arguments
   *          array of parameters for the message
   */
  public void info(String infoMessage, Object[] arguments) {
    logFormatted(Level.INFO, infoMessage, arguments);
  }

  /**
   * Formats and logs message with logging level <tt>WARNING</tt>
   * 
   * @param warningMessage
   *          a message to log
   * @param arguments
   *          array of parameters for the message
   */
  public void warning(String warningMessage, Object[] arguments) {
    logFormatted(Level.WARNING, warningMessage, arguments);
  }

  /**
   * Logs a message, with associated Throwable information and logging level
   * <tt>WARNING</tt>
   * 
   * @param warningMessage
   *          a message to log
   * @param th
   *          Throwable, associated with log message.
   */
  public void warning(String warningMessage, Throwable th) {
    log(Level.WARNING, warningMessage, th);
  }

  /**
   * Formats and logs a message, with associated Throwable information and
   * logging level <tt>WARNING</tt>
   * 
   * @param warningMessage
   *          a message to log
   * @param arguments
   *          array of parameters for the message
   * @param thrown
   *          Throwable, associated with log message
   */
  public void warning(String warningMessage, Object[] arguments, Throwable thrown) {
    logFormatted(Level.WARNING, warningMessage, arguments, thrown);
  }

  /**
   * Logs a message, with associated Throwable information and logging level
   * <tt>SEVERE</tt>
   * 
   * @param severeMessage
   *          a message to log
   * @param th
   *          Throwable, associated with log message.
   */
  public void severe(String severeMessage, Throwable th) {
    log(Level.SEVERE, severeMessage, th);
  }

  /**
   * Formats and logs message with logging level <tt>SEVERE</tt>
   * 
   * @param severeMessage
   *          a message to log
   * @param arguments
   *          array of parameters for the message
   */
  public void severe(String severeMessage, Object[] arguments) {
    logFormatted(Level.SEVERE, severeMessage, arguments);
  }

  /**
   * Formats and logs a message, with associated Throwable information and
   * logging level <tt>SEVERE</tt>
   * 
   * @param severeMessage
   *          message to log
   * @param arguments
   *          array of parameters to the message
   * @param thrown
   *          Throwable associated with log message
   */
  public void severe(String severeMessage, Object[] arguments, Throwable thrown) {
    logFormatted(Level.SEVERE, severeMessage, arguments, thrown);
  }

  /**
   * Logs a message.
   * <p>
   * Formats a message, using
   * {@link java.text.MessageFormat#format(String, Object[]) MessageFormat.format()},
   * and then logs it with
   * {@link java.util.logging.Logger#log(Level, String) Logger.log()}.
   * 
   * @param level
   *          one of the message level identifiers, e.g. SEVERE
   * @param message
   *          the string message
   * @param arguments
   *          array of parameters for the message
   */
  public void logFormatted(Level level, String message, Object[] arguments) {
    String msg = MessageFormat.format(message, arguments);
    log(level, msg);
  }

  /**
   * Logs a message, with associated Throwable information.
   * <p>
   * Formats a message using
   * {@link java.text.MessageFormat#format(String, Object[]) MessageFormat.format()},
   * and then logs it with
   * {@link java.util.logging.Logger#log(Level, String, Throwable) Logger.log()}.
   * 
   * @param level
   *          one of the message level identifiers, e.g. SEVERE
   * @param message
   *          the string message
   * @param arguments
   *          array of parameters for the message
   * @param thrown
   *          Throwable, associated with log message.
   */
  public void logFormatted(Level level, String message, Object[] arguments, Throwable thrown) {
    String msg = MessageFormat.format(message, arguments);
    log(level, msg, thrown);
  }

}
