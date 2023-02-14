package com.kavalok.billing.smscoin;

import java.lang.reflect.InvocationTargetException;
import java.math.BigInteger;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.load.Persister;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.billing.transaction.BillingTransactionUtil;
import com.kavalok.billing.transaction.TransactionConstants;
import com.kavalok.billing.transaction.TransactionProcessor;
import com.kavalok.db.Transaction;
import com.kavalok.transactions.DefaultTransactionStrategy;

public class SMSCoinUtil {

  private static Map<Integer, String> PRODUCT_TYPE_PHONE_MAP;

  private static String TRANSIT_SECRET_CODE = "chobots10141citizen";

  private static String TRANSIT_ID = "10141";

  private static Map<String, ServiceInfo> SERVICEINFO_MAP;

  private static String[] s_countr = { "RU", "UA" };

  private static List<String> SUPPORTED_COUNTRIES = Arrays.asList(s_countr);

  static {
    PRODUCT_TYPE_PHONE_MAP = new HashMap<Integer, String>();
    PRODUCT_TYPE_PHONE_MAP.put(TransactionConstants.TYPE_CITIZEN_MONTH_MEMBERSHIP, "4161");
    PRODUCT_TYPE_PHONE_MAP.put(TransactionConstants.TYPE_STUFF, "4446");

    SERVICEINFO_MAP = new HashMap<String, ServiceInfo>();

  }

  private static Logger logger = LoggerFactory.getLogger("smscoinbilling");

  public static Logger getLogger() {
    return logger;
  }

  private static String refSign(List<String> params) {
    String prehash = "";

    for (int i = 0; i < params.size(); ++i) {
      prehash += params.get(i) + ((i + 1 < params.size()) ? "::" : "");
    }

    MessageDigest m;
    try {
      m = MessageDigest.getInstance("MD5");
      m.update(prehash.getBytes(), 0, prehash.length());
      String result = new BigInteger(1, m.digest()).toString(16);
      if (result.length() == 31) {
        result = "0" + result;
      }
      return result;
    } catch (NoSuchAlgorithmException e) {
      logger.error("Cannot make MD5 sign", e);
      return null;
    }

  }

  // the function filters junk off acquired parameters
  private static String getValue(Map<String, String> params, String name) {
    String value = params.get(name);
    String result = (value != null) ? value.trim().replaceAll("<.+?>", "") : "";
    return (result.length() > 250) ? value.substring(0, 250) : value;
  }

  public static String processResultRequest(Map<String, String> requestParams) throws IllegalAccessException,
      InvocationTargetException {

    List<String> refParam = new ArrayList<String>();

    String sid = getValue(requestParams, "sid"); // service id

    // getting secret code by transit id to check if requets parameters were
    // correct
    refParam.add(TRANSIT_SECRET_CODE);

    SMSCoinRequestParams smsCoinRequestParams = new SMSCoinRequestParams();

    BeanUtils.populate(smsCoinRequestParams, requestParams);

    // collecting required data
    String country = getValue(requestParams, "country"); // country code
    refParam.add(country);
    String shortcode = getValue(requestParams, "shortcode"); // service number
    refParam.add(shortcode);
    String provider = getValue(requestParams, "provider"); // operator
    refParam.add(provider);
    String prefix = getValue(requestParams, "prefix"); // msg prefix
    refParam.add(prefix);
    String cost_local = getValue(requestParams, "cost_local"); // msg
    // cost,local
    refParam.add(cost_local);
    String cost_usd = getValue(requestParams, "cost_usd"); // msg cost,USD
    refParam.add(cost_usd);
    String phone = getValue(requestParams, "phone"); // phone number
    refParam.add(phone);
    String msgid = getValue(requestParams, "msgid"); // msg id
    refParam.add(msgid);

    refParam.add(sid);
    String content = getValue(requestParams, "content"); // msg text
    refParam.add(content);
    String sign = getValue(requestParams, "sign"); // signature

    // making the reference signature
    String reference = refSign(refParam);

    logger.info("Got params: " + requestParams);

    // validating the signature
    if (sign.equals(reference)) {
      logger.info(String.format("Processing resultURL request for phone number: %1s, text: %2s", phone, content));
      return processTransaction(content, smsCoinRequestParams);
    } else {
      logger.error(String.format("Signs are not equal, calculated: %1s, from request: %2s", reference, sign));
    }

    return "";
  }

  private static String processTransaction(String content, SMSCoinRequestParams smsCoinRequestParams) {
    // String transIdPrefix = prefix + " " + transitId + " ";
    // String transIdStr = content.substring(transIdPrefix.length() + 1);
    Long transactionId = new Long(content.toString());
    Transaction trans;

    String result = "wrong number/nepravilnyi nomer";

    boolean processTrans = true;

    DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
    try {
      dts.beforeCall();
      trans = BillingTransactionUtil.setProcessingState(dts.getSession(), transactionId, smsCoinRequestParams,
          smsCoinRequestParams.getCost_usd(), "USD");
      String number = PRODUCT_TYPE_PHONE_MAP.get(trans.getType());
      if (!smsCoinRequestParams.getShortcode().equals(number)) {
        logger.error(String.format("Phone numbers don't match. Message sent to number %1s while expected to %2s",
            smsCoinRequestParams.getShortcode(), number));
        processTrans = false;
        BillingTransactionUtil.setWrongRequestState(dts.getSession(), transactionId);
      }
      dts.afterCall();
    } catch (Exception e) {
      dts.afterError(e);
      logger.error("Error processing transaction", e);
      throw new IllegalStateException("Error calling SMSCoinUtils.processTransaction", e);
    }

    if (processTrans) {
      result = trans.getSuccessMessage();
      Thread thread = new Thread(new TransactionProcessor(transactionId));
      thread.start();
    }
    return result;
  }

  public static void main(String[] args) throws Throwable {
    ServiceInfo si = getServiceInfo(TransactionConstants.TYPE_STUFF);
    si = getServiceInfo(TransactionConstants.TYPE_STUFF);
    si.toString();
  }

  public static ServiceInfo loadServiceInfo(String phoneNumber) throws Exception {
    URL url = new URL("http://service.smscoin.com/xml/transit/" + TRANSIT_ID + "/all/");

    Serializer serializer = new Persister();
    ServiceInfo result = serializer.read(ServiceInfo.class, url.openStream());
    List<CountryInfo> countries = new ArrayList<CountryInfo>();
    for (CountryInfo country : result.getCountries()) {
      if (SUPPORTED_COUNTRIES.contains(country.getCountry()) && country.getNumber().equals(phoneNumber)) {
        countries.add(country);
      }
    }
    result.setCountries(countries);
    return result;
  }

  public static String getSMSMessage(Integer productType, String prefix, Long transactionId) throws Exception {
    return prefix + " " + TRANSIT_ID + " " + transactionId;
  }

  public static ServiceInfo getServiceInfo(Integer productType) throws Exception {
    String phoneNumber = PRODUCT_TYPE_PHONE_MAP.get(productType);
    ServiceInfo serviceInfo = SERVICEINFO_MAP.get(phoneNumber);
    if (serviceInfo == null || reloadServiceInfo(serviceInfo)) {
      serviceInfo = loadServiceInfo(phoneNumber);
      SERVICEINFO_MAP.put(phoneNumber, serviceInfo);
    }
    return serviceInfo;
  }

  private static boolean reloadServiceInfo(ServiceInfo serviceInfo) {
    GregorianCalendar now = new GregorianCalendar();
    now.setTime(new Date());
    GregorianCalendar si = new GregorianCalendar();
    si.setTime(serviceInfo.getLastLoadTime());

    return si.get(GregorianCalendar.DAY_OF_YEAR) != now.get(GregorianCalendar.DAY_OF_YEAR);

  }
}
