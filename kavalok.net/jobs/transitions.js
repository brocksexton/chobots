$(document).ready(function(){� 
� $("body").hide();� $("body").show("fade",500);� 
� $(".areaButton").click(function(){�  � var destination=$(this).attr('id');�  � 
�  � $("body").hide("fade",500,function(){�  �  � window.location=destination+".php";�  � });�  � 
� });� });