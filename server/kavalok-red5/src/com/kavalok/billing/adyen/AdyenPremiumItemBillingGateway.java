package com.kavalok.billing.adyen;

import org.red5.io.utils.ObjectMap;

import com.kavalok.billing.gateway.BillingGateway;
import com.kavalok.db.SKU;
import com.kavalok.db.Transaction;

public class AdyenPremiumItemBillingGateway extends AdyenBillingGatewayBase implements BillingGateway {

  public AdyenPremiumItemBillingGateway() {
    super("adyenrobots.properties");
    System.err.println("AdyenPremiumItemBillingGateway properties loaded");
  }

  @Override
  public ObjectMap<String, Object> generateBillingForm(Object transact) throws Exception {
    Transaction transaction = (Transaction) transact;
    SKU sku = transaction.getSku();
    return generateBillingForm(transaction.getUser(), transaction.getId(), sku.getName(), sku.getCurrencyCode(), sku
        .getPriceStr(), "");
  }

}
