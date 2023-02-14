package com.kavalok.partners;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.utils.HttpUtil;

public class LoginFromPartnerServlet extends HttpServlet {

  /**
   * 
   */
  private static final long serialVersionUID = 7412856721087050581L;

  private static final Logger logger = LoggerFactory.getLogger(LoginFromPartnerServlet.class);

  @SuppressWarnings("deprecation")
  @Override
  protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    logger.info("LoginFromPartnerServlet service called.\n URI: " + request.getRequestURI());

    try {
      Map<String, String> params = HttpUtil.normalizeRequestParameteres(request.getParameterMap());

      String result = new PartnersUtil().processLoginFromPartner(params.get("referrer"),
          params.get("referrerPassword"), params.get("user"), params.get("userEmail"), params.get("chatMode"));
      response.setContentType("text/plain");
      PrintWriter writer = response.getWriter();
      writer.print(result);
    } catch (IllegalArgumentException e) {
      logger.error("Error processing request", e);
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
    } catch (IllegalStateException e) {
      logger.error("Error processing request", e);
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
    }

  }
}
