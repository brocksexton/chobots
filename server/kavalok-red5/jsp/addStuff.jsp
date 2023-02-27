<%@ page import="
com.kavalok.dao.UserDAO, 
com.kavalok.db.User, 
com.kavalok.db.MarketingInfo, 
com.kavalok.transactions.DefaultTransactionStrategy, 
org.slf4j.Logger, 
org.slf4j.LoggerFactory,
 com.kavalok.user.UserUtil
 " %>
<%

Logger logger = LoggerFactory.getLogger("addStuffJsp");
String action = request.getParameter("action");
DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
Boolean ok = false;

if(action.equals("item")){
System.out.println("test");
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	Integer itemId = Integer.parseInt(request.getParameter("itemId"));
	Integer colour = Integer.parseInt(request.getParameter("colour"));
	Integer colorSec = 0;
	String reason = request.getParameter("reason");	
	try {
		dts.beforeCall();
		new UserUtil().addStuff(dts.getSession(), userId, itemId, colour, colorSec, reason);
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error processing transaction", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}
} else if (action.equals("citizenship")){
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	Integer months = Integer.parseInt(request.getParameter("months"));
	try {
		dts.beforeCall();
		new UserUtil().addCitizenship(dts.getSession(), userId, 0, months, "Purchased " + months + " days");
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error processing transaction", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}
} else if (action.equals("bugs")){
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	Integer amount = Integer.parseInt(request.getParameter("amount"));
	try {
		dts.beforeCall();
		new UserUtil().sendMoney(dts.getSession(), userId, amount, "");
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error processing transaction", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}
} else if (action.equals("saveStuff")){
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	String saveType = request.getParameter("type");
	String newChat = request.getParameter("new");
	Integer cost = Integer.parseInt(request.getParameter("cost"));
	try {
		dts.beforeCall();
		new UserUtil().savePurchasedStuffs(dts.getSession(), userId, saveType, newChat, cost);
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error processing transaction", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}
}


%>