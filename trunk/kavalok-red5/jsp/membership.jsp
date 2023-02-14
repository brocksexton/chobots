<%@ page import="java.util.List, com.kavalok.billing.MembershipPageService, com.kavalok.billing.SKUHtml" %>
<%
	List<SKUHtml> skus = MembershipPageService.getSKUs();
	SKUHtml sku1 = skus.get(0);
	SKUHtml sku6 = skus.get(1);
	SKUHtml sku12 = skus.get(2);
%>
  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- base href="http://www.kavalok.com/" /-->
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Chobots.com - Your Family Game! - Membership</title>
  <meta name="keywords" content="family virtual world, kids and parents, kids education, learn by playing, fun online games for children, fun games for children, online games for kids, games on line for kids, children online games, online games for children, online games for preschool, online games for preschoolers, online games for preschool children, educational online games for children, free online games for young children, online games for small children" />
  <meta name="description" content="Chobots.com is an entertaining virtual world, a family game aimed at creating an interesting, safe and learning environment for your kids." />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="-1" />
  <link rel="icon" href = "/favicon.png" type="image/png">

<link href="/stylesheets/style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="/stylesheets/membership.css" rel="stylesheet" type="text/css" media="screen" />
<style type="text/css">
<%if(sku1!=null){%>
.dragon_mask .present {background:url('/images/membership/<%= sku1.getFileName() %>.png') no-repeat top center;}
<%}%>
<%if(sku6!=null){%>
.propeller_hat .present {background:url('/images/membership/<%= sku6.getFileName() %>.png') no-repeat top center;}
<%}%>
<%if(sku12!=null){%>
.flame_wings .present {background:url('/images/membership/<%= sku12.getFileName() %>.png') no-repeat top center;}
<%}%>

</style>
</head>

<body>
	<div class="wrapper">
		<div class="content general">
  <div class="text"> 
    

<div class="menu">
  <ul>
    
    <li><span><span><a href="/index.html"><span><span>Home</span></span></a></li>
    
    <li class="current"><span><span><a href="/kavalok/jsp/membership.jsp"><span><span>Membership</span></span></a></li>
    
    <li><span><span><a href="/blog"><span><span>Community</span></span></a></li>
    
    <li><span><span><a href="/contact_us.html"><span><span>Contact us</span></span></a></li>
    
    <li class="play"><a href="/play.html#login"></a></li>

  </ul>
</div> 
<pre>
</pre>
<script>
$('.menu li:has(a[href$='+window.location.pathname+window.location.hash+']),.menu li:first').eq(0).addClass('current');
$('div.menu > ul > li a').click(function(){
  $('.menu li.current').removeClass('current');  
  $('.menu li:has(a[href$='+this.pathname+this.hash+'])').addClass('current');
})
</script>
    <div class="logo"> <a href="/"><img src="/images/logo_inner.png" alt="Chobots" /></a> </div> 
    <!-- logo --> 
    <div class="inner"> 
        
        <h1 class="title">Become a Citizen Today!</h1>

        <h2>Join Chobots premium community and get one of these exclusive items!</h2>

              <div class="right_block">
              <h1 class="title">Citizens can</h1><br><br>    
              <ul>
              <li>
              <img src="/images/membership/li_01.gif" alt="" title="" class="li_01"/>
              <span title="Draw graffiti" class="title">Draw graffiti</span>
              </li>
              <li>

              <img src="/images/membership/li_02.gif" alt="" title="" class="li_02" />
              <span title="Buy cool items" class="title">Buy cool items</span>
              </li>
              <li>
              <img src="/images/membership/li_03.gif" alt="" title="" class="li_03"/>
              <span htitle="Play more games" class="title">Play more games</span>
              </li>
              <li>

              <img src="/images/membership/li_04.gif" alt="" title="" class="li_04" />
              <span title="Join secret parties" class="title">Join secret parties</span>
              </li>
              </ul>   


              <div class="description">
              <p>After you click the Buy Now button, you will be redirected to payment system.
              </div>
     
              </div>

<div class="present_frame">
        <%if(sku1!=null){%>
	        <div class="block_present dragon_mask">
        	<form name="butt1" action="<%=sku1.getUrl()%>"><%=sku1.getParams()%></form>
	        <h3><%=sku1.getItemOfTheMonthName()%></h3>
	        <div class="round">
	            <div class="round_place"><span class="month"><ins>1</ins> month</span></div>
	            <div class="present"></div>
	
	        </div>
	        <a href="" class="img" onClick="document.forms.butt1.submit();return false;"></a>
	            <div class="desc">
	              <span>Bonus: <b><%=sku1.getBugsBonus()%> Bugs</b></span>
		        <% if(!sku1.isDiscount()){%>
	              <span>Price: <b><%=sku1.getCurrencySign()%><%=sku1.getPriceStr()%></b></span>
		        <%}else{%>
	              <span>Price: <b class="through"><i><%=sku1.getCurrencySign()%><%=sku1.getPriceStr()%></i></b> <b><%=sku1.getCurrencySign()%><%=sku1.getDiscountPriceStr()%></b></span>
		        <%}%>
	              <span>Most Popular ;-)</span>
	
	            </div>
	        </div>
        <%}%>

        <%if(sku6!=null){%>
	        <div class="block_present propeller_hat">
        	<form name="butt6" action="<%=sku6.getUrl()%>"><%=sku6.getParams()%></form>
	        <h3><%=sku6.getItemOfTheMonthName()%> <span><%=sku6.getSpecialOfferName()%></span></h3>
	        <div class="round">
	            <div class="round_place"><span class="month"><ins>6</ins> months</span></div>
	
	            <div class="present"></div>
	        </div>
	        <a href="" class="img" onClick="document.forms.butt6.submit();return false;"></a>
	            <div class="desc">
	              <span>Bonus: <b><%=sku6.getBugsBonus()%> Bugs</b></span>
		        <% if(!sku6.isDiscount()){%>
	              <span>Price: <b><%=sku6.getCurrencySign()%><%=sku6.getPriceStr()%></b></span>
	              <span>Less than <i><%=sku6.getOfferPrice()%></i> <%=sku6.getOfferCurrency()%></i> per day!</span>
		        <%}else{%>
	              <span>Price: <b class="through"><i><%=sku6.getCurrencySign()%><%=sku6.getPriceStr()%></i></b> <b><%=sku6.getCurrencySign()%><%=sku6.getDiscountPriceStr()%></b></span>
	              <span>Less than <b class="through"><i><%=sku6.getOfferPrice()%></i></b> <i><%=sku6.getOfferDiscountPrice()%></i> <%=sku6.getOfferCurrency()%></i> per day!</span>
		        <%}%>
	
	            </div>
	        </div>
        <%}%>

        <%if(sku12!=null){%>
	        <div class="block_present flame_wings">
        	<form name="butt12" action="<%=sku12.getUrl()%>"><%=sku12.getParams()%></form>
	        <h3><%=sku12.getItemOfTheMonthName()%> <span><%=sku12.getSpecialOfferName()%></span></h3>
	        <div class="round">
	            <div class="round_place"><span class="month"><ins>12</ins> months</span></div>
	
	            <div class="present"></div>
	        </div>
	        <a href="#" class="img" onClick="document.forms.butt12.submit();return false;"></a>
	            <div class="desc">
	              <span>Bonus: <b><%=sku12.getBugsBonus()%> Bugs</b></span>
		        <% if(!sku12.isDiscount()){%>
	              <span>Price: <b><%=sku12.getCurrencySign()%><%=sku12.getPriceStr()%></b></span>
	              <span>Less than <i><%=sku12.getOfferPrice()%></i> <%=sku12.getOfferCurrency()%></i> per month!</span>
		        <%}else{%>
	              <span>Price: <b class="through"><i><%=sku12.getCurrencySign()%><%=sku12.getPriceStr()%></i></b> <b><%=sku12.getCurrencySign()%><%=sku12.getDiscountPriceStr()%></b></span>
	              <span>Less than <b class="through"><i><%=sku12.getOfferPrice()%></i></b> <i><%=sku12.getOfferDiscountPrice()%></i> <%=sku12.getOfferCurrency()%></i> per month!</span>
		        <%}%>
	            </div>
	        </div>
        <%}%>
	        
        <div style="clear:both;"></div>
</div>


    <div class="price_check">

    <a href=""><img src="/images/membership/price_04.jpg" alt="" title="" /></a>
    <a href=""><img src="/images/membership/price_03.jpg" alt="" title="" /></a>
    <a href=""><img src="/images/membership/price_02.jpg" alt="" title="" /></a>
    <a href=""><img src="/images/membership/price_01.jpg" alt="" title="" /></a>
    <p>Please ask your parents to buy Chobots Citizenship.</p>
    <p>We accept payments in all currencies. A current exchange rate of your bank will be used when withdrawing the money.</p>
    </div>
        <div style="clear:left;"></div>
    </div> 
    <!-- inner --> 
  </div> 
  <div class="decor all">&nbsp;</div> 
  <!-- decor --> 

</div> 
<!-- content inner --> 

	</div>
	
  <div class="wrapper">
		<div class="footer">
			<span class="copyright">Chobots &#8482; Vayersoft LLC &copy; 2007-2009. All rights reserved.</span><br />
			<a href="/privacy_policy.html" target="_blank">Privacy Policy</a>

			<a href="/terms_and_conditions.html" target="_blank">Terms and Conditions</a>
			<!-- a href='#' class="lang"><img src="/images/lang.gif" alt="lang" /></a-->
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
