package com.kavalok.billing.adyen;

import org.red5.io.utils.ObjectMap;

import com.kavalok.billing.gateway.BillingGateway;
import com.kavalok.db.SKU;
import com.kavalok.db.Transaction;

public class AdyenBillingGateway extends AdyenBillingGatewayBase implements BillingGateway {

  public AdyenBillingGateway() {
    super("adyen.properties");
    System.err.println("AdyenBillingGateway properties loaded");
  }

  @Override
  public ObjectMap<String, Object> generateBillingForm(Object transact) throws Exception {
    Transaction transaction = (Transaction) transact;
    SKU sku = transaction.getSku();
    return generateBillingForm(transaction.getUser(), transaction.getId(), sku.getName(), sku.getCurrencyCode(), sku
        .getPriceStr(), "");
  }

}
