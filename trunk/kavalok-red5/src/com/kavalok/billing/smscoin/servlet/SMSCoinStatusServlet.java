package com.kavalok.billing.smscoin.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.kavalok.billing.smscoin.SMSCoinUtil;

public class SMSCoinStatusServlet extends HttpServlet {

  /**
   * 
   */
  private static final long serialVersionUID = -4783878530956381362L;
  
  private static Logger logger = SMSCoinUtil.getLogger();

  @Override
  protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    logger.info("SMSCoinStatusServlet service called.\n URI: " + request.getRequestURI());

  }

}
