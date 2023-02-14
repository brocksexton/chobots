package com.kavalok.transactions;

import java.util.List;

import org.red5.threadmonitoring.ThreadMonitorServices;

import com.kavalok.KavalokApplication;
import com.kavalok.utils.ReflectUtil;

public class TransactionUtil {

  public static Object callTransaction(ITransactionStrategy service, String method, List<Object> args) {
    ThreadMonitorServices.setJobDetails(
        "TransactionUtil.callTransaction(ITransactionStrategy service {0}, String method {1}, List<Object> args {2})", service,
        method, args);
    try {
      service.beforeCall();
      Object result = ReflectUtil.callMethod(service, method, args);
      service.afterCall();
      return result;
    } catch (IllegalArgumentException e) {
      service.afterError(e);
      if ("Illegal message format".trim().equals(e.getMessage().trim())) {
        KavalokApplication.logger.info("  you hacker", e);
      } else {
        KavalokApplication.logger.error(e.getMessage(), e);
      }
      throw new IllegalStateException(String.format("Error calling %1$s.%2$s", service.getClass().getName(), method), e);
    } catch (Exception e) {
      service.afterError(e);
      KavalokApplication.logger.error(e.getMessage(), e);
      throw new IllegalStateException(String.format("Error calling %1$s.%2$s", service.getClass().getName(), method), e);
    }
  }

  public static Object callTransaction(ISessionDependent service, String method, List<Object> args) {
    ThreadMonitorServices.setJobDetails(
        "TransactionUtil.callTransaction(ISessionDependent service {0}, String method {1}, List<Object> args {2})", service,
        method, args);
    DefaultTransactionStrategy strategy = new DefaultTransactionStrategy();
    try {
      strategy.beforeCall();
      service.setSession(strategy.getSession());
      Object result = ReflectUtil.callMethod(service, method, args);
      strategy.afterCall();
      return result;
    } catch (Exception e) {
      strategy.afterError(e);
      KavalokApplication.logger.error(e.getMessage(), e);
      throw new IllegalStateException(String.format("Error calling %1$s.%2$s", service.getClass().getName(), method), e);
    }
  }

}
