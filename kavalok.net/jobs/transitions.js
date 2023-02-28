$(document).ready(function(){Â 
Â $("body").hide();Â $("body").show("fade",500);Â 
Â $(".areaButton").click(function(){Â  Â var destination=$(this).attr('id');Â  Â 
Â  Â $("body").hide("fade",500,function(){Â  Â  Â window.location=destination+".php";Â  Â });Â  Â 
Â });Â });