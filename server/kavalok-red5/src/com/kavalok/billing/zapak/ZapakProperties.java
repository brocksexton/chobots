package com.kavalok.billing.zapak;

import java.io.FileReader;
import java.util.Properties;

import com.kavalok.KavalokApplication;

public class ZapakProperties {

  private static ZapakProperties instance = new ZapakProperties();

  private String sandboxPaymentUrl;

  private String livePaymentUrl;

  private String secretOutKeyLive;

  private String secretOutKeySanbox;

  private String secretInKeySanbox;

  private String secretInKeyLive;

  private ZapakProperties() {
    String path = KavalokApplication.getInstance().getClassesPath() + "/zapakbilling.properties";
    Properties properties = new Properties();
    try {
      properties.load(new FileReader(path));

      sandboxPaymentUrl = properties.getProperty("sandboxPaymentUrl");
      livePaymentUrl = properties.getProperty("livePaymentUrl");
      secretOutKeySanbox = properties.getProperty("secretOutKeySanbox");
      secretOutKeyLive = properties.getProperty("secretOutKeyLive");
      secretInKeySanbox = properties.getProperty("secretInKeySanbox");
      secretInKeyLive = properties.getProperty("secretInKeyLive");
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  public static ZapakProperties getInstance() {
    return instance;
  }

  public String getSandboxPaymentUrl() {
    return sandboxPaymentUrl;
  }

  public void setSandboxPaymentUrl(String sandboxPaymentUrl) {
    this.sandboxPaymentUrl = sandboxPaymentUrl;
  }

  public String getLivePaymentUrl() {
    return livePaymentUrl;
  }

  public void setLivePaymentUrl(String livePaymentUrl) {
    this.livePaymentUrl = livePaymentUrl;
  }

  public String getSecretOutKeyLive() {
    return secretOutKeyLive;
  }

  public void setSecretOutKeyLive(String secretOutKeyLive) {
    this.secretOutKeyLive = secretOutKeyLive;
  }

  public String getSecretOutKeySanbox() {
    return secretOutKeySanbox;
  }

  public void setSecretOutKeySanbox(String secretOutKeySanbox) {
    this.secretOutKeySanbox = secretOutKeySanbox;
  }

  public String getSecretInKeySanbox() {
    return secretInKeySanbox;
  }

  public void setSecretInKeySanbox(String secretInKeySanbox) {
    this.secretInKeySanbox = secretInKeySanbox;
  }

  public String getSecretInKeyLive() {
    return secretInKeyLive;
  }

  public void setSecretInKeyLive(String secretInKeyLive) {
    this.secretInKeyLive = secretInKeyLive;
  }

  public static void setInstance(ZapakProperties instance) {
    ZapakProperties.instance = instance;
  }

}
