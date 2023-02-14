package com.kavalok.billing.gateway;

import org.red5.io.utils.ObjectMap;

public interface RobotsBillingGateway {

  public ObjectMap<String, Object> generateBillingForm(Object transaction) throws Exception;

}
