<%@ page import="com.kavalok.dao.UserDAO, com.kavalok.db.User, com.kavalok.db.MarketingInfo, com.kavalok.transactions.DefaultTransactionStrategy, org.slf4j.Logger, org.slf4j.LoggerFactory, com.kavalok.services.AdminService" %>
<%Logger logger = LoggerFactory.getLogger("activationJSP");

 	String login = request.getParameter("login");

  DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
  try {
    dts.beforeCall();
    
    activated = (new AdminService()).kickOutJsp(dts.getSession(), login);

    dts.afterCall();
  } catch (Exception e) {
    dts.afterError(e);
    logger.error("Error processing transaction", e);
  } %><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head><center>
 
			<%
				if(activated){
			%>
			<p><b>Congratulations!<br>
			User <b><%=login%></b> was kicked!</b></p>			
			<%
				}else{
			%>
			<p><font color="red"><b>Activation key is not valid!</b></font></p>
			<%
				}
			%>
			
			</center>

</body>
</html>