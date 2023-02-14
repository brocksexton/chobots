package com.kavalok.billing.zapak;

import java.net.URLEncoder;

import org.red5.io.utils.ObjectMap;

import com.kavalok.billing.adyen.HmacEncoder;
import com.kavalok.billing.gateway.BillingGateway;
import com.kavalok.db.Transaction;

public class ZapakBillingGateway implements BillingGateway {

  private static boolean useTest = "true".equals(System.getProperty("isTestServer"));

  // http://payment.zapak.com/gateway/chobots?order_id=7624565&product_id=1&enc=1nIZAFxvzWWhApcrKt8VTpqQu3s=

  private static String SANDBOX_URL;

  private static String LIVE_URL;

  private static String currServ;

  private static String SECRET_OUT_KEY_TEST;

  private static String SECRET_OUT_KEY_PROD;

  private static String SECRET_KEY;

  // private static Logger logger =
  // LoggerFactory.getLogger("ZapakBillingGateway");

  private static boolean initialized = false;
  static {
    ZapakProperties props = ZapakProperties.getInstance();

    SANDBOX_URL = props.getSandboxPaymentUrl();
    LIVE_URL = props.getLivePaymentUrl();
    SECRET_OUT_KEY_TEST = props.getSecretOutKeySanbox();
    SECRET_OUT_KEY_PROD = props.getSecretOutKeyLive();

    currServ = useTest ? SANDBOX_URL : LIVE_URL;
    SECRET_KEY = useTest ? SECRET_OUT_KEY_TEST : SECRET_OUT_KEY_PROD;

    initialized = true;

  }

  @Override
  public ObjectMap<String, Object> generateBillingForm(Object transact) throws Exception {
    Transaction transaction = (Transaction) transact;
    if (!initialized) {
      throw new java.lang.IllegalAccessError("ZapakBillingGateway was not initialized");
    }
    if (transaction.getUser() == null) {
      return null;
    }

    String hmacData = transaction.getId().toString() + "," + transaction.getSku().getProductId();
    String enc = HmacEncoder.calculateRFC2104HMAC(hmacData, SECRET_KEY);

    ObjectMap<String, Object> result = new ObjectMap<String, Object>();
    ObjectMap<String, String> parameters = new ObjectMap<String, String>();

    parameters.put("orderid", transaction.getId().toString());
    parameters.put("productid", transaction.getSku().getProductId());
    parameters.put("enc", enc);

    result.put("url", currServ);
    result.put("parameters", parameters);

    return result;
  }
}
