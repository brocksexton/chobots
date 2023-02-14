package org.red5.threadmonitoring;


public class ThreadMonitorModelComparator implements java.util.Comparator, java.io.Serializable {
  
  private static ThreadMonitorModelComparator instance  = new ThreadMonitorModelComparator();
  public static ThreadMonitorModelComparator getInstance(){
    return instance;
  }

  public int compare(Object o1, Object o2) {
    ThreadMonitorModel model1 = (ThreadMonitorModel) o1;
    ThreadMonitorModel model2 = (ThreadMonitorModel) o2;

    String type1 = model1.getType();
    String type2 = model2.getType();

    long time1 = model1.getStartTime();
    long time2 = model2.getStartTime();

    // all null values to the end;
    if (type1 != null || type2 != null) {
      if (type1 == null)
        return 1;
      if (type2 == null)
        return -1;
    }

    // compare types only if they are not the same
    if (type1 != null && type2 != null && !type1.equals(type2))
      return type2.compareTo(type1);

    // smaller times goes up
    return (int) (time1 - time2);
  }

}