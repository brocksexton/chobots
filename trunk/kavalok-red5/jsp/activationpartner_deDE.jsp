<%@ page import="com.kavalok.dao.UserDAO, com.kavalok.db.User, com.kavalok.db.MarketingInfo, com.kavalok.transactions.DefaultTransactionStrategy, org.slf4j.Logger, org.slf4j.LoggerFactory, com.kavalok.user.UserUtil" %>


<% 
	Logger logger = LoggerFactory.getLogger("activationpartnerJSP");

 	String activationKey = request.getParameter("activationKey");
 	String login = request.getParameter("login");
 	Boolean chatEnabled = "1".equals(request.getParameter("chatEnabled"));
 	
 	String chatType = chatEnabled?"Vollchat":"dem sicheren Chat";
	boolean activated = false;
	String redirectUrl = "";

  DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
  try {
    dts.beforeCall();

    logger.info("activating login: "+login + " activationKey: "+activationKey+" chatEnabled: " +chatEnabled);
    
    activated = (new UserUtil()).activateAccount(dts.getSession(), login, activationKey, chatEnabled);
    
    UserDAO userDao = new UserDAO(dts.getSession());
    com.kavalok.db.User user = userDao.findByLogin(login);
    MarketingInfo mi =  user.getMarketingInfo();
    redirectUrl = mi.getActivationUrl();

    dts.afterCall();
  } catch (Exception e) {
    dts.afterError(e);
    logger.error("Error processing transaction", e);
  }
 %><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>Chobots.de - Dein Familienspiel!</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="keywords" content="Familie virtuell Welt, Kinder und Eltern, Kinderausbildung, spielend lernen, lustige online Spiele fur Kinder, lustige Spiele fur Kinder, online Spiele fur Kinder, Spiele on line fur Kinder, Kinder online Spiele, online Spiele fur Kinder, online Spiele fur Grundschule, online Spiele fur Grundschuler, online Spiele fur Grundschule Kinder, Bildungsspiele, bildende online Spiele fur Kinder, kostenlose online Spiele fur kleine Kinder, online Spiele fur kleine Kinder" />
  <meta name="description" content="Chobots.de ist eine lustige virtuelle Welt, ein Familienspiel, der zum Ziel Interesseherstellung, sichere Ausbildungsumgebung fur Ihre Kinder hat." />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="-1" />
	<link rel="stylesheet" href="/stylesheets/style.css" type="text/css" media="screen" title="no title" charset="utf-8" />

	<!--[if IE]><link rel="stylesheet" href="/stylesheets/ie.css" type="text/css" media="screen" title="no title" charset="utf-8" /><![endif]-->
	<script>
	  var ch_locale = 'deDE';
	  var ch_language = 'de';
	</script>
  <script src="/javascripts/game.js" type="text/javascript"></script> 
	
<style>
  div.ingame {
    display:none;
  }
</style>


	
</head>
<body>
	<div class="wrapper">

		
<div class="content index2">
	<div class="text" style="height: 650px">
    
		<div class="inner">

			<h1 class="title">Chobots Kontoaktivierung</h1>
			<%
				if(activated){
			%>
			<script>
				function redirect(){
					window.location = "<%=redirectUrl%>"
				
				}
				setTimeout('redirect()', 10000)
			</script>
			<p><b>Glückwunsch!<br>
			Dein Konto mit <b><%=chatType%></b> wurde erfolgreich aktiviert. Viel Spaß beim Spielen!<br>
			In wenigen Sekunden wirst Du zu Chobots weitergeleitet.<br>
			Falls Du nicht weitergeleitet wurdest, klicke folgendes Link an: <a href="<%=redirectUrl%>"><%=redirectUrl%></p>			
			<%
				}else{
			%>
			<p><font color="red"><b>Aktivierungsschlüssel ist nicht gultig!</b></font></p>
			<%
				}
			%>
		</div>

	</div> <!-- wrapper -->

  <script type="text/javascript">
		var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
		document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
	</script>
	<script type="text/javascript">
		var pageTracker = _gat._getTracker("UA-5914122-1");
    pageTracker._setDomainName("none");
    pageTracker._setAllowLinker(true);
    pageTracker._initData();
		pageTracker._trackPageview();
	</script>

  <!-- Start Quantcast tag -->
  <script type="text/javascript">
  _qoptions={
  qacct:"p-0aP0z-r3jkFbM"
  };
  </script>
  <script type="text/javascript" src="http://edge.quantserve.com/quant.js"></script>

  <noscript>
  <img src="http://pixel.quantserve.com/pixel/p-0aP0z-r3jkFbM.gif" style="display: none;" border="0" height="1" width="1" alt="Quantcast"/>
  </noscript>
  <!-- End Quantcast tag -->
</body>
</html>
 
 
