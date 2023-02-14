package com.kavalok.billing.adyen;

import org.red5.io.utils.ObjectMap;

import com.kavalok.billing.gateway.RobotsBillingGateway;
import com.kavalok.db.RobotSKU;
import com.kavalok.db.RobotTransaction;

public class AdyenRobotsBillingGateway extends AdyenBillingGatewayBase implements RobotsBillingGateway {

  public AdyenRobotsBillingGateway() {
    super("adyenrobots.properties");
    System.err.println("AdyenRobotsBillingGateway properties loaded");
  }

  @Override
  public ObjectMap<String, Object> generateBillingForm(Object transact) throws Exception {
    RobotTransaction transaction = (RobotTransaction) transact;
    RobotSKU sku = transaction.getRobotSKU();
    return generateBillingForm(transaction.getUser(), transaction.getId(), sku.getName(), sku.getCurrencyCode(), sku
        .getPriceStr(), "R");
  }

}
