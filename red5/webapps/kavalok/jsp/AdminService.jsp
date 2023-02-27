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

Logger logger = LoggerFactory.getLogger("AdminServiceJsp");
String action = request.getParameter("action");
DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
Boolean ok = false;

if(action.equals("kick")){
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	try {
		dts.beforeCall();
		new UserUtil().kickHimOut(userId, false, dts.getSession());
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}
} else if (action.equals("ban")){
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	String reason = request.getParameter("reason");	
	try {
		dts.beforeCall();
		new UserUtil().saveUserBan(dts.getSession(), userId, true, reason, null);
		new UserUtil().kickHimOut(userId, true, dts.getSession());
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}
} else if (action.equals("ipban")){
	String ip = request.getParameter("ip");
	String reason = request.getParameter("reason");	
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	try {
		dts.beforeCall();
		new UserUtil().saveIPBan(dts.getSession(), ip, true, reason);
		if(userId != null) {
			new UserUtil().kickHimOut(userId, true, dts.getSession());
		}
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}
} else if (action.equals("saveData")){
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	Boolean activated = Integer.valueOf(request.getParameter("activated")) == 1 ? true : false;	
	Boolean chatEnabled = Integer.valueOf(request.getParameter("chatEnabled")) == 1 ? true : false;	
	Boolean chatEnabledByParent = Integer.valueOf(request.getParameter("chatEnabledByParent")) == 1 ? true : false;	
	Boolean agent = Integer.valueOf(request.getParameter("agent")) == 1 ? true : false;	
	Boolean baned = Integer.valueOf(request.getParameter("baned")) == 1 ? true : false;	
	Boolean drawEnabled = Integer.valueOf(request.getParameter("drawEnabled")) == 1 ? true : false;	
	Boolean artist = Integer.valueOf(request.getParameter("artist")) == 1 ? true : false;	
	String status = request.getParameter("status");	
	Boolean pictureChat = Integer.valueOf(request.getParameter("pictureChat")) == 1 ? true : false;	
	
	try {
		dts.beforeCall();
		new UserUtil().saveUserData(dts.getSession(), userId, activated, chatEnabled, chatEnabledByParent, agent, baned, drawEnabled, artist, status, pictureChat);
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}
} else if (action.equals("saveBadgeData")) {
	Integer userId = Integer.parseInt(request.getParameter("userId"));
	Boolean agent = Integer.valueOf(request.getParameter("agent")) == 1 ? true : false;	
	Boolean moderator = Integer.valueOf(request.getParameter("moderator")) == 1 ? true : false;	
	Boolean dev = Integer.valueOf(request.getParameter("dev")) == 1 ? true : false;	
	Boolean des = Integer.valueOf(request.getParameter("des")) == 1 ? true : false;	
	Boolean staff = Integer.valueOf(request.getParameter("staff")) == 1 ? true : false;	
	Boolean support = Integer.valueOf(request.getParameter("support")) == 1 ? true : false;	
	Boolean artist = Integer.valueOf(request.getParameter("artist")) == 1 ? true : false;	
	Boolean journalist = Integer.valueOf(request.getParameter("journalist")) == 1 ? true : false;
	Boolean scout = Integer.valueOf(request.getParameter("scout")) == 1 ? true : false;	
	Boolean forumer = Integer.valueOf(request.getParameter("forumer")) == 1 ? true : false;	
	
	try {
		dts.beforeCall();
		new UserUtil().saveBadgeData(dts.getSession(), userId, agent, moderator, dev, des, staff, support, journalist, scout, forumer);
		dts.afterCall();
		ok = true;
	} catch (Exception e) {
		dts.afterError(e);
		logger.error("Error", e);
	} finally {
		if(ok){
			out.println("OK");
		} else {
			out.println("FAIL");
		}
	}

}



%>