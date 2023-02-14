package org.red5.threadmonitoring;

import antlr.collections.Stack;

/**
 * 
 * Model for storing and retrieving information about currently monitored
 * thread's activity. <br>
 */
public class ThreadMonitorModel {

  private Thread thread;

  private ThreadMonitorModel parent;

  private long startTime;

  private String job;

  private long detailsStartTime;

  private String details;

  private Object[] detailParametersList = new Object[5];

  private Object[] detailParameters;

  private StringBuffer log;

  private String type;

  private boolean formatted = false;

  /**
   * Constructs <code>ThreadMonitorModel</code> instance with specified job
   * name. StartTime is set to current time value. Thread is set to current
   * thread value.
   * 
   * @param job
   *          job name to create model with
   */
  public ThreadMonitorModel(String job) {
    this.job = job;
    this.startTime = System.currentTimeMillis();
    this.thread = Thread.currentThread();
  }

  /**
   * Returns the details.
   * 
   * @return String
   */
  public String getDetails() {
    if (!formatted && details != null) {
      long detailTime = System.currentTimeMillis() - getDetailsStartTime();
      if (detailTime != 0) {
        if (extractActiveDetailParameters() != null) {
          String details = MessageFormat.format(this.details, extractActiveDetailParameters());
          this.details = details;
        }
        StringBuffer detail = new StringBuffer();
        detail.append(detailTime).append('.').append(this.details).append('\n');
        this.details = detail.toString();

        formatted = true;
      }

    }

    return details;
  }

  /**
   * Returns the detailsStartTime.
   * 
   * @return long
   */
  public long getDetailsStartTime() {
    return detailsStartTime;
  }

  /**
   * Returns the job.
   * 
   * @return String
   */
  public String getJob() {
    return job;
  }

  public String getStackTrace() {
    StackTraceElement[] traceArr = this.thread.getStackTrace();
    StringBuffer result = new StringBuffer();
    for (int i = 0; i < traceArr.length; i++) {
      StackTraceElement s = traceArr[i];
      result.append("\tat ").append(s.getClassName()).append(".").append(s.getMethodName()).append("(").append(
          s.getFileName()).append(":").append(s.getLineNumber()).append(")\n");
    }
    return result.toString();
  }

  /**
   * Returns the startTime.
   * 
   * @return long
   */
  public long getStartTime() {
    return startTime;
  }

  /**
   * Returns the type.
   * 
   * @return String
   */
  public String getType() {
    return type;
  }

  /**
   * Sets the details.
   * 
   * @param details
   *          The details to set
   */
  public void setDetails(String details) {
    this.details = details;
    this.detailsStartTime = System.currentTimeMillis();

    formatted = false;
  }

  Object[] extractActiveDetailParameters() {

    Object result[] = null;

    if (detailParameters != null) {
      result = detailParameters;
    } else if (detailParametersList[0] != null) {
      result = detailParametersList;
    }
    return result;
  }

  void clearDetailsParameters() {

    detailParameters = null;
    detailParametersList[0] = null;
  }

  /**
   * Sets the job.
   * 
   * @param job
   *          The job to set
   */
  public void setJob(String job) {
    this.job = job;
  }

  /**
   * Sets the type.
   * 
   * @param type
   *          The type to set
   */
  public void setType(String type) {
    this.type = type;
  }

  /**
   * Returns the thread.
   * 
   * @return Thread
   */
  public Thread getThread() {
    return thread;
  }

  /**
   * Sets the thread.
   * 
   * @param thread
   *          The thread to set
   */
  public void setThread(Thread thread) {
    this.thread = thread;
  }

  /**
   * Returns log buffer value.
   * 
   * @return log buffer value
   */
  public StringBuffer getLog() {
    if (log == null) {
      this.log = new StringBuffer();
    }

    return log;
  }

  /**
   * Sets log buffer.
   * 
   * @param buffer
   *          buffer to set
   */
  public void setLog(StringBuffer buffer) {
    log = buffer;
  }

  // ************************
  // SUB DETAILS PART
  // ************************
  private SimpleStack subDetails = new SimpleStack();

  private Object[] subDetailsParameters;

  private Object[] subDetailsParametersList = new Object[5];

  /**
   * Pop current subDetail.
   * 
   * @return current subdetail.
   */
  public long popSubDetails() {
    return subDetails.pop();
  }


  public void pushSubDetails() {
    this.subDetails.push(System.currentTimeMillis());
  }

  /**
   * Returns number of subDetails.
   * 
   * @return number of subDetails
   */
  public int sizeOfSubDetails() {
    return this.subDetails.size();
  }

  Object[] extractActiveSubDetailParameters() {

    Object result[] = null;

    if (subDetailsParameters != null) {
      result = subDetailsParameters;
    } else if (subDetailsParametersList[0] != null) {
      result = subDetailsParametersList;
    }
    return result;
  }

  void clearSubDetailsParameters() {

    subDetailsParameters = null;
    subDetailsParametersList[0] = null;
  }

  Object[] getDetailParameters() {
    return detailParameters;
  }

  void setDetailParameters(Object[] detailParameters) {
    this.detailParameters = detailParameters;
  }

  Object[] getDetailParametersList() {
    return detailParametersList;
  }

  void setDetailParametersList(Object[] detailParametersList) {
    this.detailParametersList = detailParametersList;
  }

  ThreadMonitorModel getParent() {
    return parent;
  }

  void setParent(ThreadMonitorModel parent) {
    this.parent = parent;
  }

  Object[] getSubDetailsParameters() {
    return subDetailsParameters;
  }

  void setSubDetailsParameters(Object[] subDetailsParameters) {
    this.subDetailsParameters = subDetailsParameters;
  }

  Object[] getSubDetailsParametersList() {
    return subDetailsParametersList;
  }

  void setSubDetailsParametersList(Object[] subDetailsParametersList) {
    this.subDetailsParametersList = subDetailsParametersList;
  }
}