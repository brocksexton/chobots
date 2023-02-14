package com.kavalok
{
	import com.google.analytics.GATracker;
	import com.google.analytics.debug.DebugConfiguration;
	import com.google.analytics.v4.Configuration;
	
	import flash.display.DisplayObject;

	public class GoogleATracker extends GATracker
	{
		
		private var homeURL : String;
		
		public function GoogleATracker(display:DisplayObject, account:String, mode:String = "AS3", visualDebug:Boolean = false, config:Configuration = null, debug:DebugConfiguration = null)
		{
			super(display, account, mode, visualDebug, config, debug);
			homeURL = Global.startupInfo.redirectURL;
			var httpIndex : int = homeURL.indexOf("http://");
			if(httpIndex>=0)
				homeURL = homeURL.substr(httpIndex+"http://".length);
			if(homeURL.charAt(homeURL.length-1)=='/')
				homeURL = homeURL.substr(0, homeURL.length-1);
			homeURL = "/" + homeURL;
			
		}
		
		override public function trackPageview(content : String = "") : void
		{
		super.trackPageview(homeURL+content);
		}
		
	}
}