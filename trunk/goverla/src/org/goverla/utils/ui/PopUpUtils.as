package org.goverla.utils.ui {

	import flash.geom.Point;
	
	import mx.core.IUIComponent;
	import mx.core.Application;
	
	public class PopUpUtils	{
		
    	public static function locatePopUp(popup : IUIComponent, target : IUIComponent, 
    	        positioningMethod : String = "rlbt", safeBorder : int = 5, 
    	        xGap : int = 0, yGap : int = 0) : void {

            var method : String = positioningMethod.toLocaleLowerCase();
            
    	    var targetLeft : Boolean = (method.charAt(0) == "l");
    	    var popupLeft  : Boolean = (method.charAt(1) == "l");

    	    var targetTop  : Boolean = (method.charAt(2) == "t");
    	    var popupTop   : Boolean = (method.charAt(3) == "t");
    
        	var topLeft : Point = target.parent.localToGlobal(new Point(target.x, target.y));
        	var bottomRight: Point = target.parent.localToGlobal(new Point(target.x + target.width, target.y + target.height));
        	
			popup.x = (targetLeft ? topLeft.x : bottomRight.x) + (popupLeft ? xGap : (-popup.width - xGap));
		    if( (popup.x + popup.width > Application.application.width - safeBorder) || (popup.x < safeBorder) ){
    			popup.x = (!targetLeft ? topLeft.x : bottomRight.x) + (!popupLeft ? xGap : (-popup.width - xGap));
		    }			
		    if(popup.x + popup.width > Application.application.width - safeBorder){
    			popup.x = Application.application.width - safeBorder - popup.width;
		    }			
		    if( popup.x < safeBorder ){ popup.x = safeBorder; }			
		    
			popup.y = (targetTop ? topLeft.y : bottomRight.y) + (popupTop ? yGap : (-popup.height - yGap));
 		    if ( (popup.y + popup.height > Application.application.height - safeBorder) || (popup.y < safeBorder) ){
    			popup.y = (!targetTop ? topLeft.y : bottomRight.y) + (!popupTop ? yGap : (-popup.height - yGap));
		    }
 		    if (popup.y + popup.height > Application.application.height - safeBorder){
    			popup.y = Application.application.height - safeBorder - popup.height;
		    }
 		    if (popup.y < safeBorder){ popup.y = safeBorder; }
		    
		}

    	public static function safePositioningPopUp(popup : IUIComponent, safeBorder : int = 5) : void {
		    if(popup.x + popup.width > Application.application.width - safeBorder){
    			popup.x = Application.application.width - safeBorder - popup.width;
		    }			
		    if( popup.x < safeBorder ){ popup.x = safeBorder; }			

 		    if (popup.y + popup.height > Application.application.height - safeBorder){
    			popup.y = Application.application.height - safeBorder - popup.height;
		    }
 		    if (popup.y < safeBorder){ popup.y = safeBorder; }
		}
		
	}
}