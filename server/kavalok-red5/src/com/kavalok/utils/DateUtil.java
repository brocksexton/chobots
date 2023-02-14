package com.kavalok.utils;

import java.util.Date;
import java.util.GregorianCalendar;

public class DateUtil {

  public static long daysDiff(Date date1, Date date2) {
    long m1 = date1.getTime();
    long m2 = date2.getTime();
    long diff = m1 - m2;
    return diff / (24 * 60 * 60 * 1000);
  }

  public static long minutesDiff(Date date1, Date date2) {
    long m1 = date1.getTime();
    long m2 = date2.getTime();
    long diff = m1 - m2;
    return diff / (60 * 1000);
  }

  public static long hoursDiff(Date date1, Date date2) {
    long m1 = date1.getTime();
    long m2 = date2.getTime();
    long diff = m1 - m2;
    return diff / (60 * 60 * 1000);
  }

  public static boolean daysFollowing(Date date1,  Date date2) {
    GregorianCalendar gc1 = new GregorianCalendar();
    gc1.setTime(date1);
    GregorianCalendar gc2 = new GregorianCalendar();
    gc2.setTime(date2);
    gc1.add(GregorianCalendar.DAY_OF_YEAR, 1);

    return gc1.get(GregorianCalendar.YEAR) == gc2.get(GregorianCalendar.YEAR)
        && gc1.get(GregorianCalendar.DAY_OF_YEAR) == gc2.get(GregorianCalendar.DAY_OF_YEAR);
  }

  public static boolean sameDay(Date date1, Date date2) {
    GregorianCalendar gc1 = new GregorianCalendar();
    gc1.setTime(date1);
    GregorianCalendar gc2 = new GregorianCalendar();
    gc2.setTime(date2);

    return gc1.get(GregorianCalendar.YEAR) == gc2.get(GregorianCalendar.YEAR)
        && gc1.get(GregorianCalendar.DAY_OF_YEAR) == gc2.get(GregorianCalendar.DAY_OF_YEAR);
  }
}
