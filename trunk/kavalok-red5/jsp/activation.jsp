<%@ page import="com.kavalok.dao.UserDAO, com.kavalok.db.User, com.kavalok.db.MarketingInfo, com.kavalok.transactions.DefaultTransactionStrategy, org.slf4j.Logger, org.slf4j.LoggerFactory, com.kavalok.user.UserUtil" %>
<%Logger logger = LoggerFactory.getLogger("activationJSP");

 	String activationKey = request.getParameter("activationKey");
 	String login = request.getParameter("login");
 	Boolean chatEnabled = "1".equals(request.getParameter("chatEnabled"));
 	
 	String chatType = chatEnabled?"full":"safe";
	boolean activated = false;

  DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
  try {
    dts.beforeCall();

    logger.info("activating login: "+login + " activationKey: "+activationKey+" chatEnabled: " +chatEnabled);
    
    activated = (new UserUtil()).activateAccount(dts.getSession(), login, activationKey, chatEnabled);

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
			Your account is successfully activated with <b><%=chatType%></b> chat. Have fun playing!</b></p>			
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