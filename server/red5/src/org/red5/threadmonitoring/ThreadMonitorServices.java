package org.red5.threadmonitoring;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.EmptyStackException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;

/**
 * ThreadMonitorServices class provides information about what threads currently
 * are doing. <br>
 * It also has a feature of logging structure log entries in thread in details
 * log <br>
 * the usage is simple :<br>
 * start(&quot;my thread&quot;); ... setJobType(&quot;my type&quot;);
 * setJobDetails(&quot;starting init&quot;); ... setJobDetails(&quot;the action
 * part 1&quot;); ... startJobSubDetails(); ... startJobSubDetails();
 * stopJobSubDetails(&quot;some small part of sub action&quot;); ...
 * startJobSubDetails(); stopJobSubDetails(&quot;some other small part of sub
 * action&quot;); ... stopJobSubDetails(&quot;the end of sub action&quot;); ...
 * setJobDetails(&quot;the action part 2&quot;); ... finish(); is permited <br>
 * each of thouse start/stop pairs will be stored as loged in structurical way
 * <br>
 * here is the tempalte <br>
 * INFO: job :[JOB TYPE]: [JOB NAME] time.[jobSubDetails] time.[jobDetails] the
 * example how it will look in our code Nov 12, 2003 12:31:38 AM
 * com.componence.utils.logging.Logger log INFO: job :my type:my thread
 * 20.starting init 25.some small part of sub action 20.some other small part of
 * sub action 119.the end of sub action 159.the action part 1 finished took.237
 */

public class ThreadMonitorServices {

  private static ThreadMonitorServices instance = new ThreadMonitorServices();

  public static ThreadMonitorServices getInstance() {
    return instance;
  }

  private static int logBufferSize = 0;

  private static int minimalThreadTimeToLog = 0;

  private static boolean LOG = false;

  /**
   * Sets all thread information (jobs, job details and job subdetails) to be
   * loggable.
   */
  public static void setLogable() {
    LOG = true;
  }

  /**
   * Returns TRUE if current thread information is loggable.
   * 
   * @return TRUE if jobs and job details are loggable
   */
  public static boolean isLogable() {
    return LOG;
  }

  /**
   * Sets all thread information to unloggable state and resets all log buffers
   * of monitored threads.
   */
  public static void setUnLogable() {

    if (LOG == false) {
      return;
    }

    LOG = false;
    // clear all the logs
    synchronized (monitor) {
      for (Iterator it = monitor.entrySet().iterator(); it.hasNext();) {
        Map.Entry entry = (Map.Entry) it.next();
        ThreadMonitorModel element = (ThreadMonitorModel) entry.getValue();
        element.setLog(new StringBuffer());
      }
    }
  }

  private static Map monitor = new HashMap();

  /**
   * Creates new <code>ThreadMonitorModel</code> instance with specified
   * <code>job</code> parameter and sets it as current monitored model for
   * current thread. If another job is already started it is set as a parent for
   * the newly created job.
   * 
   * @param job
   *          job to create <code>ThreadMonitorModel</code> instance with
   */
  public static void start(String job) {
    Object threadKey = getThreadKey();
    ThreadMonitorModel parentJobDescriptor = (ThreadMonitorModel) monitor.get(threadKey);
    ThreadMonitorModel currentJobDescriptor = new ThreadMonitorModel(job);

    currentJobDescriptor.setParent(parentJobDescriptor);

    synchronized (monitor) {
      monitor.put(threadKey, currentJobDescriptor);
    }
  }

  /**
   * Sets new job name for currently monitored thread.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param job
   *          new job name for currently monitored thread
   */
  public static void setJob(String job) {
    ThreadMonitorModel jobDescriptor = getJob();
    if (jobDescriptor == null) {
      return;
    }
    jobDescriptor.setJob(job);
  }

  private static Object getThreadKey() {
    return Thread.currentThread();
  }

  private static ThreadMonitorModel getJob() {
    return (ThreadMonitorModel) monitor.get(getThreadKey());
  }

  /**
   * Sets new job details. If there are old job details, stores their log info
   * in a log buffer for currently monitored thread.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param details
   *          details for currently monitored thread to be logged
   */
  public static void setJobDetails(String details) {
    setJobDetails(details, null);
  }

  /**
   * Sets new job details. If there are old job details, stores their log info
   * in a log buffer for currently monitored thread. Uses <code>params</code>
   * to format details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param details
   *          details for currently monitored thread to be logged
   * @param params
   *          arguments used to format details message
   */
  public static void setJobDetails(String details, Object[] params) {
    ThreadMonitorModel jobDescriptor = getJob();
    if (jobDescriptor == null) {
      return;
    }

    if (jobDescriptor.getDetails() != null) {
      // contained previouse details, log their death
      logDetail(jobDescriptor);
    }

    jobDescriptor.setDetailParameters(params);
    jobDescriptor.setDetails(details);

  }

  /**
   * Sets new job details. If there are old job details, stores their log info
   * in a log buffer for currently monitored thread. Uses given parameter to
   * format details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param details
   *          details for currently monitored thread to be logged
   * @param param0
   *          argument used to format details message
   */
  public static void setJobDetails(String details, Object param0) {
    setJobDetails(details, param0, null, null, null, null);
  }

  /**
   * Sets new job details. If there are old job details, stores their log info
   * in a log buffer for currently monitored thread. Uses given parameters to
   * format details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param details
   *          details for currently monitored thread to be logged
   * @param param0
   *          argument used to format details message
   * @param param1
   *          argument used to format details message
   */
  public static void setJobDetails(String details, Object param0, Object param1) {
    setJobDetails(details, param0, param1, null, null, null);
  }

  /**
   * Sets new job details. If there are old job details, stores their log info
   * in a log buffer for currently monitored thread. Uses given parameters to
   * format details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param details
   *          details for currently monitored thread to be logged
   * @param param0
   *          argument used to format details message
   * @param param1
   *          argument used to format details message
   * @param param2
   *          argument used to format details message
   */

  public static void setJobDetails(String details, Object param0, Object param1, Object param2) {
    setJobDetails(details, param0, param1, param2, null, null);
  }

  /**
   * Sets new job details. If there are old job details, stores their log info
   * in a log buffer for currently monitored thread. Uses given parameters to
   * format details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param details
   *          details for currently monitored thread to be logged
   * @param param0
   *          argument used to format details message
   * @param param1
   *          argument used to format details message
   * @param param2
   *          argument used to format details message
   * @param param3
   *          argument used to format details message
   */
  public static void setJobDetails(String details, Object param0, Object param1, Object param2, Object param3) {
    setJobDetails(details, param0, param1, param2, param3, null);
  }

  /**
   * Sets new job details. If there are old job details, stores their log info
   * in a log buffer for currently monitored thread. Uses given parameters to
   * format details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param details
   *          details for currently monitored thread to be logged
   * @param param0
   *          argument used to format details message
   * @param param1
   *          argument used to format details message
   * @param param2
   *          argument used to format details message
   * @param param3
   *          argument used to format details message
   * @param param4
   *          argument used to format details message
   */
  public static void setJobDetails(String details, Object param0, Object param1, Object param2, Object param3,
      Object param4) {

    ThreadMonitorModel jobDescriptor = getJob();
    if (jobDescriptor == null) {
      return;
    }

    if (jobDescriptor.getDetails() != null) {
      // contained previouse details, log their death
      logDetail(jobDescriptor);
    }

    jobDescriptor.getDetailParametersList()[0] = param0;
    jobDescriptor.getDetailParametersList()[1] = param1;
    jobDescriptor.getDetailParametersList()[2] = param2;
    jobDescriptor.getDetailParametersList()[3] = param3;
    jobDescriptor.getDetailParametersList()[4] = param4;

    jobDescriptor.setDetails(details);
  }

  /**
   * Starts a structural detail of a job in current thread. <br>
   * For each start operation, stopJobSubDetails(String subDetails) should be
   * called.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   */
  public static void startJobSubDetails() {
    ThreadMonitorModel jobDescriptor = getJob();
    if (jobDescriptor == null) {
      return;
    }

    jobDescriptor.pushSubDetails();
  }

  /**
   * Stores the subDetails log info in a log buffer for currently monitored
   * thread.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param subDetails
   *          sub details for current thread to be logged
   */
  public static void stopJobSubDetails(String subDetails) {
    stopJobSubDetails(subDetails, null);
  }

  /**
   * Stores the subDetails log info in a log buffer for currently monitored
   * thread. Uses given parameters to format subdetails message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param subDetails
   *          sub details for current thread to be logged
   * @param params
   *          to format sub details message
   */
  public static void stopJobSubDetails(String subDetails, Object[] params) {
    ThreadMonitorModel jobDescriptor = getJob();
    if (jobDescriptor == null) {
      return;
    }

    jobDescriptor.setSubDetailsParameters(params);
    logSubDetail(subDetails, jobDescriptor);
  }

  /**
   * Stores the subDetails log info in a log buffer for currently monitored
   * thread. Uses given parameter to format sub details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param subDetails
   *          sub details for current thread to be logged
   * @param param0
   *          argument used to format sub details message
   */
  public static void stopJobSubDetails(String subDetails, Object param0) {
    stopJobSubDetails(subDetails, param0, null, null, null, null);
  }

  /**
   * Stores the subDetails log info in a log buffer for currently monitored
   * thread. Uses given parameters to format sub details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param subDetails
   *          sub details for current thread to be logged
   * @param param0
   *          argument used to format sub details message
   * @param param1
   *          argument used to format sub details message
   */
  public static void stopJobSubDetails(String subDetails, Object param0, Object param1) {
    stopJobSubDetails(subDetails, param0, param1, null, null, null);
  }

  /**
   * Stores the subDetails log info in a log buffer for currently monitored
   * thread. Uses given parameters to format sub details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param subDetails
   *          sub details for current thread to be logged
   * @param param0
   *          argument used to format sub details message
   * @param param1
   *          argument used to format sub details message
   * @param param2
   *          argument used to format sub details message
   */
  public static void stopJobSubDetails(String subDetails, Object param0, Object param1, Object param2) {
    stopJobSubDetails(subDetails, param0, param1, param2, null, null);
  }

  /**
   * Stores the subDetails log info in a log buffer for currently monitored
   * thread. Uses given parameters to format sub details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param subDetails
   *          sub details for current thread to be logged
   * @param param0
   *          argument used to format sub details message
   * @param param1
   *          argument used to format sub details message
   * @param param2
   *          argument used to format sub details message
   * @param param3
   *          argument used to format sub details message
   */
  public static void stopJobSubDetails(String subDetails, Object param0, Object param1, Object param2, Object param3) {
    stopJobSubDetails(subDetails, param0, param1, param2, param3, null);
  }

  /**
   * Stores the subDetails log info in a log buffer for currently monitored
   * thread. Uses given parameters to format sub details message with
   * {@link java.text.MessageFormat#format(java.lang.String, java.lang.Object[]) MessageFormat#format(String, Object[])}.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param subDetails
   *          sub details for current thread to be logged
   * @param param0
   *          argument used to format sub details message
   * @param param1
   *          argument used to format sub details message
   * @param param2
   *          argument used to format sub details message
   * @param param3
   *          argument used to format sub details message
   * @param param4
   *          argument used to format sub details message
   */
  public static void stopJobSubDetails(String subDetails, Object param0, Object param1, Object param2, Object param3,
      Object param4) {
    ThreadMonitorModel jobDescriptor = getJob();
    if (jobDescriptor == null) {
      return;
    }

    jobDescriptor.getSubDetailsParametersList()[0] = param0;
    jobDescriptor.getSubDetailsParametersList()[1] = param1;
    jobDescriptor.getSubDetailsParametersList()[2] = param2;
    jobDescriptor.getSubDetailsParametersList()[3] = param3;
    jobDescriptor.getSubDetailsParametersList()[4] = param4;

    logSubDetail(subDetails, jobDescriptor);
  }

  /**
   * Sets the current job type.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   * 
   * @param type
   *          type of current job to be set
   */
  public static void setJobType(String type) {
    ThreadMonitorModel jobDescriptor = getJob();
    if (jobDescriptor == null) {
      return;
    }
    jobDescriptor.setType(type);
  }

  /**
   * Gets the current job type. <br>
   * 
   * @return type of current job, or <code>null</code> if there is no
   *         currently monitored thread
   */
  public static String getJobType() {
    ThreadMonitorModel jobDescriptor = getJob();
    return jobDescriptor != null ? jobDescriptor.getType() : null;
  }

  /**
   * Logs currently monitored thread information and releases it (stops
   * monitoring). If there was another job set previously, it is set as current
   * job of this thread.
   * <p>
   * Note: Does nothing if there is no currently monitored thread.
   */
  public static void finish() {
    ThreadMonitorModel currentJob = getJob();

    if (currentJob == null) {
      return;
    }

	try {
	    logFinish(currentJob);
	} catch ( Throwable t ) {
		System.err.println("ThreadMonitorService.finish, oops - something went terribly wrong in the finish method");
		t.printStackTrace();
	}

    if (currentJob.getParent() != null) {

      synchronized (monitor) {
        monitor.put(getThreadKey(), currentJob.getParent());
      }

    } else {

      synchronized (monitor) {
        monitor.remove(getThreadKey());
      }
    }

  }

  /**
   * Logs information of each monitored thread and stops monitoring it.
   */
  public static void finishAll() {
    Object threadKey = getThreadKey();

    while (monitor.containsKey(threadKey)) {
      finish();
    }
  }

  /**
   * Returns a list of <code>ThradMonitorModel</code> details of active
   * threads.
   * 
   * @return list of <code>ThradMonitorModel</code> details of active threads
   */
  public static List getMonitor() {
    // create a local monitor by activeCount
    List localMonitor = new ArrayList(monitor.size());
    // sync on monitors, iterate and populate
    synchronized (monitor) {
      for (Iterator it = monitor.entrySet().iterator(); it.hasNext();) {
        Map.Entry entry = (Map.Entry) it.next();
        ThreadMonitorModel element = (ThreadMonitorModel) entry.getValue();
        localMonitor.add(element);
      }
    }
    return localMonitor;
  }

  private static void logDetail(ThreadMonitorModel job) {
    if (LOG) {
      long now = System.currentTimeMillis();
      long detailTime = now - job.getDetailsStartTime();
      if (detailTime != 0) {
        job.getLog().append(now - job.getStartTime()).append(':').append(job.getDetails());
      }
    }

    job.clearDetailsParameters();
  }

  private static void logSubDetail(String subDetails, ThreadMonitorModel job) {
    if (LOG) {

      long subDetailTime = 0;
      long now = System.currentTimeMillis();

      try {
        subDetailTime = now - job.popSubDetails();
      } catch (EmptyStackException e) {
        throw new ThreadMonitorException("Job sub details were not started.");
      }

      if (subDetailTime != 0) {
        // indent
        StringBuffer log = job.getLog();

        for (int x = 0; x <= job.sizeOfSubDetails(); x++) {
          log.append("  ");
        }

        // adding subdetail time stamp
        log.append(now - job.getStartTime()).append(":");

        // printing the time

        if (job.extractActiveSubDetailParameters() != null) {
          subDetails = MessageFormat.format(subDetails, job.extractActiveSubDetailParameters());
        }
        log.append(subDetailTime).append('.').append(subDetails);

        log.append('\n');
      }
    }

    job.clearSubDetailsParameters();
  }

  private static void logFinish(ThreadMonitorModel job) {
    if (LOG) {
      // can be empty
      if (job != null && (job.getType() != null || job.getJob() != null)) {
        long timeTook = System.currentTimeMillis() - job.getStartTime();
        if (timeTook < minimalThreadTimeToLog)
          return;
        StringBuffer log = job.getLog();
        // is less than 20, no sence to log
        if (log.length() != 0) {

          log.insert(0, '\n').insert(0, job.getJob()).insert(0, ':').insert(0, job.getType()).insert(0, ':').insert(0,
              "job ");

          log.append("finished took").append('.').append(timeTook).append('\n');

          if (getLogger() != null) {
            getLogger().log(Level.INFO, log.toString());
          }
        }
      }
    }
  }

  // logger
  private static Logger logger;

  /**
   * Returns logger that logs all monitored thread's details.
   * 
   * @return logger that logs all monitored thread's details
   */
  public static Logger getLogger() {
    return logger;
  }

  /**
   * Sets the Logger object that logs all monitored thread's details
   * 
   * @param logger
   *          logger to be set
   */
  public static void setLogger(Logger logger) {
    ThreadMonitorServices.logger = logger;
  }

  public static int getLogBufferSize() {
    return logBufferSize;
  }

  public static void setLogBufferSize(int logBufferSize) {
    ThreadMonitorServices.logBufferSize = logBufferSize;
  }

  public static int getMinimalThreadTimeToLog() {
    return minimalThreadTimeToLog;
  }

  public static void setMinimalThreadTimeToLog(int minimalThreadTimeToLog) {
    ThreadMonitorServices.minimalThreadTimeToLog = minimalThreadTimeToLog;
  }

}