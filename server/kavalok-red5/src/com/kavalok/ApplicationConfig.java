package com.kavalok;

import java.util.Properties;

import net.sf.cglib.core.ReflectUtils;

import com.kavalok.billing.gateway.BillingGateway;
import com.kavalok.billing.gateway.RobotsBillingGateway;

public class ApplicationConfig {

  private Properties applicationProperties;

  private String host;

  private String charSet;

  private String videoPlayerURL;

  private String petHelpURL;

  private String termsAndConditionsURL;

  private String blogURL;

  private BillingGateway billingGateway;

  private BillingGateway premiumItemBillingGateway;

  private RobotsBillingGateway robotsBillingGateway;

  private String emailsenderName = "Chobots.world";

  private String emailsenderAddress = "noreply@chobots.world";

  private int maxPaymentsSumPerMonth = 100;

  public ApplicationConfig(Properties applicationProperties) {
    this.applicationProperties = applicationProperties;
    this.host = this.applicationProperties.getProperty("instance.host");
    this.charSet = this.applicationProperties.getProperty("instance.charSet");
    this.videoPlayerURL = this.applicationProperties.getProperty("instance.videoPlayerURL");
    this.petHelpURL = this.applicationProperties.getProperty("instance.petHelpURL");
    this.termsAndConditionsURL = this.applicationProperties.getProperty("instance.termsAndConditionsURL");
    this.blogURL = this.applicationProperties.getProperty("instance.blogURL");
    this.emailsenderName = this.applicationProperties.getProperty("instance.emailsender.name", "Chobots.world Team");
    this.emailsenderAddress = this.applicationProperties.getProperty("instance.emailsender.address",
        "noreply@chobotsuniverse.com");
    try {
      this.maxPaymentsSumPerMonth = Integer.parseInt(this.applicationProperties
          .getProperty("instance.max_payments_sum_per_month"));
    } catch (NumberFormatException e) {
    }
  }

  public String getCharSet() {
    return charSet;
  }

  public String getVideoPlayerURL() {
    return videoPlayerURL;
  }

  public String getPetHelpURL() {
    return petHelpURL;
  }

  public String getTermsAndConditionsURL() {
    return termsAndConditionsURL;
  }

  public String getBlogURL() {
    return blogURL;
  }

  public String getHost() {
    return host;
  }

  public BillingGateway getBillingGateway() throws InstantiationException, IllegalAccessException,
      ClassNotFoundException {
    if (this.billingGateway != null) {
      return this.billingGateway;
    }
    String billingGatewayClassName = this.applicationProperties.getProperty("instance.billingGatewayClass");
    if (billingGatewayClassName == null) {
      // use Adyen by default
      billingGatewayClassName = "com.kavalok.billing.adyen.AdyenBillingGateway";
    }
    this.billingGateway = (BillingGateway) ReflectUtils.newInstance(Class.forName(billingGatewayClassName));
    return this.billingGateway;
  }

  public BillingGateway getPremiumItemBillingGateway() throws InstantiationException, IllegalAccessException,
      ClassNotFoundException {
    if (this.premiumItemBillingGateway != null) {
      return this.premiumItemBillingGateway;
    }
    String billingGatewayClassName = this.applicationProperties.getProperty("instance.premiumItemGatewayClass");
    if (billingGatewayClassName == null) {
      // use Adyen by default
      billingGatewayClassName = "com.kavalok.billing.adyen.AdyenPremiumItemBillingGateway";
    }
    this.premiumItemBillingGateway = (BillingGateway) ReflectUtils.newInstance(Class.forName(billingGatewayClassName));
    return this.premiumItemBillingGateway;
  }

  public RobotsBillingGateway getRobotsBillingGateway() throws InstantiationException, IllegalAccessException,
      ClassNotFoundException {
    if (this.robotsBillingGateway != null) {
      return this.robotsBillingGateway;
    }
    String billingGatewayClassName = this.applicationProperties.getProperty("instance.robotsBillingGatewayClass");
    if (billingGatewayClassName == null) {
      // use Adyen by default
      billingGatewayClassName = "com.kavalok.billing.adyen.AdyenRobotsBillingGateway";
    }
    this.robotsBillingGateway = (RobotsBillingGateway) ReflectUtils.newInstance(Class.forName(billingGatewayClassName));
    return this.robotsBillingGateway;
  }

  public String getEmailsenderName() {
    return emailsenderName;
  }

  public void setEmailsenderName(String emailsenderName) {
    this.emailsenderName = emailsenderName;
  }

  public String getEmailsenderAddress() {
    return emailsenderAddress;
  }

  public void setEmailsenderAddress(String emailsenderAddress) {
    this.emailsenderAddress = emailsenderAddress;
  }

  public int getMaxPaymentsSumPerMonth() {
    return maxPaymentsSumPerMonth;
  }

  public void setMaxPaymentsSumPerMonth(int maxPaymentsSumPerMonth) {
    this.maxPaymentsSumPerMonth = maxPaymentsSumPerMonth;
  }

}
