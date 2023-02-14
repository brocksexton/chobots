package com.kavalok.billing.paypal.servlet;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.kavalok.billing.paypal.PayPalUtil;
import com.kavalok.utils.HttpUtil;

public class PaypalIPNServlet extends HttpServlet {

  /**
   * 
   */
  private static final long serialVersionUID = -5039011533303614797L;

  private static Logger logger = PayPalUtil.getLogger();

  @Override
  protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    logger.info("PayPalUtilIPNServlet servlet called.\n: " + request.getRequestURI());

    try {
      String result = PayPalUtil.processResultRequest(HttpUtil.normalizeRequestParameteres(request.getParameterMap()));
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().write(result);
    } catch (IllegalAccessException e) {
      logger.error("Error processing request", e);
    } catch (InvocationTargetException e) {
      logger.error("Error processing request", e);
    }

  }
}
