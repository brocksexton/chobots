package com.kavalok.billing.smscoin.servlet;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.kavalok.billing.smscoin.SMSCoinUtil;
import com.kavalok.utils.HttpUtil;

public class SMSCoinResultServlet extends HttpServlet {

  /**
   * 
   */
  private static final long serialVersionUID = 9166772327665369872L;
  
  private static Logger logger = SMSCoinUtil.getLogger();

  @Override
  protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    logger.info("SMSCoinResultServlet service called.\n URI: " + request.getRequestURI());

    try {
      String result = SMSCoinUtil.processResultRequest(HttpUtil.normalizeRequestParameteres(request.getParameterMap()));
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().write(result);
    } catch (IllegalAccessException e) {
      logger.error("Error processing request", e);
    } catch (InvocationTargetException e) {
      logger.error("Error processing request", e);
    }

  }
}
