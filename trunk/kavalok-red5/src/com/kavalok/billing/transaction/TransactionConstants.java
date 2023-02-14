package com.kavalok.billing.transaction;

import java.util.HashMap;
import java.util.Map;

public class TransactionConstants {

  public static final Byte STATE_NEW = 0;

  public static final Byte STATE_PROCESSING = 1;

  public static final Byte WRONG_REQUEST = 4;

  public static final Byte STATE_DONE = 2;

  public static final Byte STATE_REFUND = 66;

  public static final Byte STATE_NO_SUCH_PRODUCT = 3;

  public static final int TYPE_STUFF = 1;

  public static final int TYPE_CHANGE_LOGIN = 2;

  public static final int TYPE_CITIZEN_MONTH_MEMBERSHIP_OLD = 0;

  public static final int TYPE_CITIZEN_MONTH_MEMBERSHIP = 100;

  public static final int TYPE_CITIZEN_MONTH_MEMBERSHIP_OLD1 = 10;

  public static final int TYPE_CITIZEN_3_MONTHS_MEMBERSHIP = 3;

  public static final int TYPE_CITIZEN_6_MONTHS_MEMBERSHIP_OLD = 4;

  public static final int TYPE_CITIZEN_6_MONTHS_MEMBERSHIP = 40;

  public static final int TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_OLD = 5;

  public static final int TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_OLD1 = 50;

  public static final int TYPE_CITIZEN_12_MONTHS_MEMBERSHIP = 500;

  public static final int TYPE_CITIZEN_MONTH_MEMBERSHIP_PROLONG_OLD = 6;

  public static final int TYPE_CITIZEN_MONTH_MEMBERSHIP_PROLONG = 600;

  public static final int TYPE_CITIZEN_MONTH_MEMBERSHIP_PROLONG_OLD1 = 60;

  public static final int TYPE_CITIZEN_3_MONTHS_MEMBERSHIP_PROLONG = 7;

  public static final int TYPE_CITIZEN_6_MONTHS_MEMBERSHIP_PROLONG_OLD = 8;

  public static final int TYPE_CITIZEN_6_MONTHS_MEMBERSHIP_PROLONG = 80;

  public static final int TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_PROLONG_OLD = 9;

  public static final int TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_PROLONG_OLD1 = 90;

  public static final int TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_PROLONG = 900;

  public static final Map<Integer, Double> PACKAGE_PRICES;

  static {
    PACKAGE_PRICES = new HashMap<Integer, Double>();

    PACKAGE_PRICES.put(TYPE_CITIZEN_MONTH_MEMBERSHIP_OLD, 5.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_MONTH_MEMBERSHIP_OLD1, 6.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_MONTH_MEMBERSHIP, 7.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_3_MONTHS_MEMBERSHIP, 16.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_6_MONTHS_MEMBERSHIP_OLD, 25.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_6_MONTHS_MEMBERSHIP, 29.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_OLD, 35.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_OLD1, 47.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_12_MONTHS_MEMBERSHIP, 57.99);

    PACKAGE_PRICES.put(TYPE_CITIZEN_MONTH_MEMBERSHIP_PROLONG_OLD, 5.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_MONTH_MEMBERSHIP_PROLONG_OLD1, 6.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_MONTH_MEMBERSHIP_PROLONG, 7.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_3_MONTHS_MEMBERSHIP_PROLONG, 16.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_6_MONTHS_MEMBERSHIP_PROLONG_OLD, 25.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_6_MONTHS_MEMBERSHIP_PROLONG, 29.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_PROLONG_OLD, 35.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_PROLONG_OLD1, 47.99);
    PACKAGE_PRICES.put(TYPE_CITIZEN_12_MONTHS_MEMBERSHIP_PROLONG, 57.99);
  }

}
