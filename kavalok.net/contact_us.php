<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title><?php echo $c_url; ?> - Your Family Game!</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="keywords" content="family virtual world, kids and parents, kids education, learn by playing, fun online games for children, fun games for children, online games for kids, games on line for kids, children online games, online games for children, online games for preschool, online games for preschoolers, online games for preschool children, educational online games for children, free online games for young children, online games for small children"/>
<meta name="description" content="<?php echo $c_url; ?> is an entertaining virtual world, a family game aimed at creating an interesting, safe and learning environment for your kids."/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="-1"/>
<link rel="icon" href="/favicon.png" type="image/png">
<link rel="stylesheet" href="/stylesheets/style.css" type="text/css" media="screen" title="no title" charset="utf-8"/>
<!--[if IE]><link rel="stylesheet" href="/stylesheets/ie.css" type="text/css" media="screen" title="no title" charset="utf-8" /><![endif]-->
<script type="text/javascript">
	  var ch_locale = 'enUS';
	  var ch_language = 'en';
	</script>
<script src="/javascripts/game.js" type="text/javascript"></script>
</head>
<body>
<div class="wrapper">
<script type="text/javascript">
  function disable(){
    return false;
  }
  $(function(){
    
    $('form').submit(function(){
      $('.error').removeClass('error');
      $('.error_message ul').empty();
      $('.error_message').hide();
      $('.success_message').hide();

      $('.required:has(input[value=],textarea[value=])').each(function(){
        $(this).addClass('error');
        $('.error_message ul').append('<li>'+$('input,textarea', this).attr('name')+' cannot be empty');
        $('.error_message').show();
      })

      if ( $('.error').length == 0 ) {
  	    var data = $(this).serialize();
  	    $('.contactForm').addClass('loading');
  	    
        jQuery.get( this.action, data, function(data, textStatus){
          var json = eval('('+data+')');
          if ( textStatus == "success" && json=="success" ) {
            $('.success_message').show();
          } else {
            for(var i=0;i<json.error.length;i++) {
              error=json.error[i];
              if ( error.field ) {
                $('p:has(input[name='+error.field+'],textarea[name='+error.field+'])').addClass('error');
              }                
              $('.error_message ul').append('<li>'+error.message);
              $('.error_message').show();
            }
          }
    	    $('.contactForm').removeClass('loading');
        })
      }
      
      return false;
    })
  })
</script>
<style>.error label{color:red!important;}.error_message{display:none;}.error_message ul{margin:0!important;}.error_message ul li{color:red!important;list-style:circle!important;margin-left:15px!important;width:80%!important;}.success_message{display:none;color:green!important;}p.iText label span{color:#00B3ED;display:inline;font-family:"trebuchet MS";font-size:15px;padding-right:5px;}.loading .loader{display:block!important;}.loading .disableWhileLoading{opacity:0.15;filter:alpha(opacity= 15);zoom:1;}.loader{display:none;margin-bottom:0;margin-left:250px;margin-right:0;margin-top:-46px;position:absolute;}.clear{clear:both;}</style>
<form>
<div class="content general">
<div class="text">
<div class="menu">
<ul>
    <li class="current"><span><span><a href="/index"><span><span>Home</span></span></a></li>
	<li><span><span><a href="/management/shop"><span><span>Shop</span></span></a></li>
	<li><span><span><a href="http://blog.<?php echo $url; ?>/"><span><span>Community</span></span></a></li>
	<li><span><span><a href="/management"><span><span>Management</span></span></a></li>
    <li><span><span><a href="http://<?php echo $url; ?>/market/"><span><span>Market</span></span></a></li>
	<li class="play"><a href="/play"></a></li>
</ul>
</div>
<pre>
</pre>
<script type="text/javascript">
$('.menu li:has(a[href$='+window.location.pathname+window.location.hash+']),.menu li:first').eq(0).addClass('current');
$('div.menu > ul > li a').click(function(){
  $('.menu li.current').removeClass('current');  
  $('.menu li:has(a[href$='+this.pathname+this.hash+'])').addClass('current');
})
</script>
<div class="logo"> <a href="/"><img src="/images/logo_inner.png" alt="Chobots"/></a> </div>
 
<h1 class="title">We love to talk. What do you want to talk about today?</h1>
<div class="inner">
<div class="contactForm">

<h2>Got questions? We got answers!</h2>
<ul>
<li><img src="/images/skype.gif" alt=""/> <a href="skype:sheenieboy999">Sheenieboy</a></li>
<li class="iSkype"><span>Chat</span><b>Anytime<br/></b></li>
</ul>
<div class="error_message">
<p>Your message was not sent for the following reason(s):</p>
<ul></ul>
</div>


</div>
<div class="blockInfo">



<li><img src="/management/images/buyshards.png" alt="Shards"><center></li>

</div>
<div class="success_message">
<p>Your message was successfully sent!</p>
</div>
</div>
</div>
 
</div>
<div class="decor all">&nbsp;</div>
 
</div>
</div>
<div class="wrapper">
<div class="footer">
<span class="copyright">Chobots &#8482; Vayersoft LLC &copy; 2007-2010. Chobots &#8482; <?php echo $c_url; ?> &copy; 2012-2014<br/> All rights reserved.</span><br/>
<a href="/privacy" target="_blank">Privacy Policy</a>
<a href="/terms" target="_blank">Terms and Conditions</a>
<a href="/jobs" target="_blank">Jobs with <?php echo $c_url; ?></a>
</div>
</div>  
</body>
</html>
