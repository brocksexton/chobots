package com.kavalok.billing.adyen;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Properties;
import java.util.zip.GZIPOutputStream;

import org.apache.commons.codec.binary.Base64;
import org.red5.io.utils.ObjectMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.KavalokApplication;
import com.kavalok.billing.gateway.BillingGateway;
import com.kavalok.db.User;

public abstract class AdyenBillingGatewayBase implements BillingGateway {

  private String ACCOUNT_NAME = "Chobots";

  private String SKIN_CODE = "W3mz1Nf0";

  private String COUNTRY_CODE = "US";

  private String SHOPPER_LOCALE = "en";

  private boolean useTest = "true".equals(System.getProperty("isTestServer"));

  private String strSandbox = "https://test.adyen.com/hpp/pay.shtml";

  private String strLive = "https://live.adyen.com/hpp/pay.shtml";

  private String currServ = useTest ? strSandbox : strLive;

  private String SECRET_KEY_TEST = "ChobotsComIsCoolW3mz1Nf0Test";

  private String SECRET_KEY_PROD = "ChobotsComIsCoolW3mz1Nf0";

  private String SECRET_KEY = useTest ? SECRET_KEY_TEST : SECRET_KEY_PROD;

  private final SimpleDateFormat shipBeforeDateFormat = new SimpleDateFormat("yyyy-MM-dd");

  private final SimpleDateFormat sessionValidityDateFormat = new SimpleDateFormat("HH:mm:ssZ");

  private Logger logger = LoggerFactory.getLogger("AdyenBillingGateway");

  private boolean initialized = false;

  public AdyenBillingGatewayBase(String propertiesFileName) {
    String path = KavalokApplication.getInstance().getClassesPath() + "/" + propertiesFileName;
    System.err.println("Loading property file: " + path);
    Properties properties = new Properties();
    try {
      properties.load(new FileReader(path));

      ACCOUNT_NAME = properties.getProperty("ACCOUNT_NAME");
      SKIN_CODE = properties.getProperty("SKIN_CODE");
      SECRET_KEY_TEST = properties.getProperty("SECRET_KEY_TEST");
      SECRET_KEY_PROD = properties.getProperty("SECRET_KEY_PROD");
      COUNTRY_CODE = properties.getProperty("COUNTRY_CODE");
      SHOPPER_LOCALE = properties.getProperty("SHOPPER_LOCALE");

      currServ = useTest ? strSandbox : strLive;
      SECRET_KEY = useTest ? SECRET_KEY_TEST : SECRET_KEY_PROD;

      initialized = true;

    } catch (FileNotFoundException e) {
      logger.error("Problem initializing AdyenBillingGateway", e);
    } catch (IOException e) {
      logger.error("Problem initializing AdyenBillingGateway", e);
    }

  }

  protected ObjectMap<String, Object> generateBillingForm(User user, Long transactionId, String skuName,
      String skuCurrencyCode, String skuPriceStr, String txPrefix) throws Exception {
    if (!initialized) {
      throw new java.lang.IllegalAccessError("AdyenBillingGateway was not initialized");
    }

    GregorianCalendar gc = new GregorianCalendar();
    gc.setTime(new Date());
    gc.add(GregorianCalendar.DAY_OF_YEAR, 1);

    String merchantReference = skuName + " (" + txPrefix + transactionId.toString() + ")";

    String paymentAmount = skuPriceStr.replace(".", "");
    String currencyCode = skuCurrencyCode;
    String skinCode = SKIN_CODE;
    String merchantAccount = ACCOUNT_NAME;
    String shopperLocale = SHOPPER_LOCALE;
    String countryCode = COUNTRY_CODE;
    String userIdData = "";
    String userLoginData = "Unknown";
    if (user != null) {
      userIdData = "$%$" + user.getId();
      userLoginData = user.getLogin();
    }
    String orderDataNorm = "<span style=\"display:none\">" + skuName + "$%$" + userLoginData + "$%$" + txPrefix
        + transactionId + userIdData + "</span>";
    String orderData = encodeOrderData(orderDataNorm);

    String shipBeforeDate = shipBeforeDateFormat.format(gc.getTime());
    gc.add(GregorianCalendar.YEAR, 1);
    String sessionValidity = shipBeforeDateFormat.format(gc.getTime()) + "T"
        + sessionValidityDateFormat.format(gc.getTime());

    sessionValidity = sessionValidity.substring(0, sessionValidity.length() - 2) + ":"
        + sessionValidity.substring(sessionValidity.length() - 2);

    String shopperReference = transactionId.toString();
    String shopperEmail = "transaction-" + transactionId.toString() + "@chobots.com";

    if (user != null) {
      if (user.getEmail().indexOf("@") > 0)
        shopperEmail = user.getEmail();
      shopperReference = user.getId().toString();
    }

    String hmacData = paymentAmount + currencyCode + shipBeforeDate + merchantReference + skinCode + merchantAccount
        + sessionValidity + shopperEmail + shopperReference;

    String merchantSig = HmacEncoder.calculateRFC2104HMAC(hmacData, SECRET_KEY);

    ObjectMap<String, Object> result = new ObjectMap<String, Object>();
    ObjectMap<String, String> parameters = new ObjectMap<String, String>();

    parameters.put("merchantReference", merchantReference);
    parameters.put("paymentAmount", paymentAmount);
    parameters.put("currencyCode", currencyCode);
    parameters.put("skinCode", skinCode);
    parameters.put("merchantAccount", merchantAccount);
    parameters.put("shopperLocale", shopperLocale);
    parameters.put("countryCode", countryCode);
    parameters.put("orderData", orderData);
    parameters.put("shipBeforeDate", shipBeforeDate);
    parameters.put("sessionValidity", sessionValidity);
    parameters.put("shopperEmail", shopperEmail);
    parameters.put("shopperReference", shopperReference);
    parameters.put("merchantSig", merchantSig);

    result.put("url", currServ);
    result.put("parameters", parameters);

    return result;
  }

  private String encodeOrderData(String value) {
    String result = value;
    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    BufferedOutputStream bufos;
    try {
      bufos = new BufferedOutputStream(new GZIPOutputStream(bos));
      bufos.write(value.getBytes());
      bufos.close();
    } catch (IOException e) {
      logger.error("Error while encoding Order Data", e);
    }
    result = new String(Base64.encodeBase64(bos.toByteArray()));
    try {
      bos.close();
    } catch (IOException e) {
      logger.error("Error while encoding Order Data", e);
    }
    return result;
  }

  public abstract ObjectMap<String, Object> generateBillingForm(Object transaction) throws Exception;

}
