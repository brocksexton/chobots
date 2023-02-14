<%@ page import="
java.io.IOException,
java.io.PrintStream,
java.sql.ResultSet,
java.sql.SQLException,
java.sql.Statement,
java.util.List,
java.util.Collections,
java.util.Collection,
java.util.Comparator,
java.util.HashMap,
java.util.Map,
java.util.HashSet,
java.util.Set,
java.util.Iterator,
javax.servlet.http.HttpServletRequest,
javax.servlet.http.HttpServletResponse,
javax.servlet.jsp.JspWriter,
org.red5.threadmonitoring.ThreadMonitorModelComparator,
org.red5.threadmonitoring.ThreadMonitorModel,
org.red5.threadmonitoring.ThreadMonitorServices,
java.io.BufferedOutputStream,
java.io.FileNotFoundException,
java.io.FileOutputStream,
java.io.File,
java.util.logging.SimpleFormatter,
java.util.logging.StreamHandler,
org.red5.threadmonitoring.Logger


" %>

<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

<%!

  public static boolean isDebugMode(HttpServletRequest request) {
    HttpSession session = request.getSession();
    String value = request.getParameter("debugMode");
    if ( value != null ) {
      if ( Boolean.valueOf(value) ) {
        session.setAttribute("debugMode", Boolean.TRUE);
      } else {
        session.removeAttribute("debugMode");
      }
    }
    return session.getAttribute("debugMode") != null;
  }

  public static void populateJobTypeFilter(HttpServletRequest request) {
    Set hiddenSettings = getJobTypeHiddenSettings(request);

    String value = request.getParameter("filterJobType");
    if ( value != null && value.length() >= 2 ) {
      char direction = value.charAt(0);
      String key = value.substring(1, value.length());
      if (direction == '-') {
        hiddenSettings.add(key);
      } else {
        hiddenSettings.remove(key); 
      }
    }
  }

  public static HashSet getJobTypeHiddenSettings(HttpServletRequest request){
    HttpSession session = request.getSession();
    HashSet set = (HashSet)session.getAttribute("JobTypeHiddenSettings");
    if ( set == null ) {
      set = new HashSet();
      session.setAttribute("JobTypeHiddenSettings", set);
    }
    return set;
  }
  
  public static String getStackTrace(Thread thread) {
    StackTraceElement[] traceArr = thread.getStackTrace();
    StringBuffer result = new StringBuffer();
    for (int i = 0; i < traceArr.length; i++) {
      StackTraceElement s = traceArr[i];
      result.append("\tat ").append(s.getClassName()).append(".").append(s.getMethodName()).append("(").append(
          s.getFileName()).append(":").append(s.getLineNumber()).append(")\n");
    }
    return result.toString();
  }
  

  public static void process(HttpServletRequest request, HttpServletResponse response, JspWriter out) throws IOException {
    ThreadMonitorServices.finish();
    populateJobTypeFilter(request);

    boolean logJobs = false;
    boolean debug = isDebugMode(request);
    String log = (String)request.getParameter("logJobs");

    if (log == null) {
      logJobs = ThreadMonitorServices.isLogable();
    } else {
      logJobs = Boolean.valueOf(log).booleanValue();
      if ( logJobs ) {
	    String logBuffSize = request.getParameter("logBuffSize");
	    Integer buffSize = 0;
	    try {
	      buffSize = new Integer(logBuffSize);
	    } catch (NumberFormatException e) {
	
	    }
	    String minimalThreadTimeToLogStr = request.getParameter("minimalThreadTimeToLog");
	    Integer minimalThreadTimeToLog = 0;
	    try {
	      minimalThreadTimeToLog = new Integer(minimalThreadTimeToLogStr);
	    } catch (NumberFormatException e) {
	
	    }
	    BufferedOutputStream bufferedOutputStream;
	    File logFile = new File("./log/ThreadMonitorServices.log");
	    System.err.println("logFile: "+logFile.getAbsolutePath());
	    if (buffSize >= 256) {
	      bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(logFile), buffSize);
	    } else {
	      bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(logFile));
	    }
	    Logger logger = new Logger("ThreadMonitorServices");
	    logger.addHandler(new StreamHandler(bufferedOutputStream, new SimpleFormatter()));
	    ThreadMonitorServices.setLogger(logger);
        ThreadMonitorServices.setLogBufferSize(buffSize);
        ThreadMonitorServices.setMinimalThreadTimeToLog(minimalThreadTimeToLog);
        ThreadMonitorServices.setLogable();
      } else {
        ThreadMonitorServices.setUnLogable();
      }
    }

    List values = ThreadMonitorServices.getMonitor();

    Comparator comparator = ThreadMonitorModelComparator.getInstance();
    Collections.sort(values, comparator);
    
    out.println("<table><tr><td>");
    out.println( "Thread count : "+values.size());
    out.println("</td><td>");
    out.println("<a href='?'> refresh</a>");
    out.println("<a href='?debugMode="+(!debug)+"'>"+(debug?"stop":"start")+" debug mode</a>");    
    out.println("</td><td>");
    Iterator hiddenJobTypes = getJobTypeHiddenSettings(request).iterator();
    out.println("hidden jobTypes:");
    while(hiddenJobTypes.hasNext()){
       String jobType = (String)hiddenJobTypes.next();
       out.println(jobType+" <a href='?filterJobType=+"+jobType+"'>[X]</a>");
    } 
    out.println("</td><td>");
    if(logJobs){
	    out.println("<a href='?logJobs="+(!logJobs)+"'>"+(logJobs?"stop":"start")+" logs</a>");
	    out.println("log buffer size: "+ThreadMonitorServices.getLogBufferSize());
	    out.println(" minimum thread time to log: "+ThreadMonitorServices.getMinimalThreadTimeToLog());
    }else{
	    out.print("<form action='?'>");
	    out.println("<input type='hidden' name='logJobs' value='"+(!logJobs)+"'>");
	    out.println("log buffer size<input name='logBuffSize' value='"+ThreadMonitorServices.getLogBufferSize()+"'>");
	    out.println(" minimum thread time to log<input name='minimalThreadTimeToLog' value='"+ThreadMonitorServices.getMinimalThreadTimeToLog()+"'>");
	    out.println("<input type='submit' value ='start logs'></form>");
    }
    out.println("</td></tr></table>");

    if ( !values.isEmpty() ) {

      ThreadMonitorModel model = (ThreadMonitorModel)values.get(0);
      String lastType = ""; 
      
      Iterator it = values.iterator();
      while (it.hasNext()) {
        model = (ThreadMonitorModel)it.next();
        if ( getJobTypeHiddenSettings(request).contains(model.getType()) ) {
          continue;
        }

        Thread thread = model.getThread();
        int threadId = System.identityHashCode( thread );

        long now = System.currentTimeMillis();
          
        // type changed
        if ( lastType != null && !lastType.equals(model.getType()) ) {
          if (lastType.length()!=0)
            out.println( "</table>" );

          lastType = model.getType();

          out.println( "<center><h3>"+lastType+" <a href='?filterJobType=-"+lastType+"'>hide</a></h3></center>");
          out.println( "<table cellspacing='0' cellpadding='2' border='1'>" );
        }

        float jobTime = now-model.getStartTime();
        jobTime = jobTime / 1000;
        
        out.print( "<tr><td> "+jobTime+"</td><td>"+model.getJob()+"</td><td>"+thread.getName()+"<span style='display:none' id='"+thread.getName()+"'>"+(debug ? getStackTrace(thread) : "")+"</span>");
        if(debug) {
          out.println( " <a href='#' onClick=\"alert(document.getElementById('"+thread.getName()+"').innerHTML);return false;\">stacktrace</a> ");
        }
        out.println( "</td><tr>");
        
        if ( model.getDetails() != null ) {
          float jobDetailTime = now - model.getDetailsStartTime();
          jobDetailTime = jobDetailTime/1000;

          out.println( "<tr><td>"+jobDetailTime+"</td><td colspan='2'>"+model.getDetails()+"</td><tr>");
        }

        out.println( "<tr><td colspan='3'><hr></td></tr>");
      }
      out.println( "</table>" );
    } else {
      out.println( "no jobs" );
    }
  }

  private static void processWithErrors(HttpServletRequest request, HttpServletResponse response, JspWriter out) throws IOException, SQLException {
    Exception wrappedException = null;

    try {
      out.println("<pre>");
      process(request, response, out);
      out.println("</pre>");
    } catch (Exception e) {
      wrappedException = e;
    }
    
    if (wrappedException != null) {
      out.write("<pre>\n");
      wrappedException.printStackTrace();
      out.write("</pre>\n");
    }
  }
  
%>
<% processWithErrors(request, response, out); %>
