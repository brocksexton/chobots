package com.kavalok.location.commands
{
	import com.junkbyte.console.Cc;
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest; // console
	
	public class NotificationCommand extends RemoteLocationCommand
	{
		public var notify:String;
		
		
		public function NotificationCommand()
		{
			Cc.log("notification instantiated");
			
			super();
		}
		
		override public function execute():void
		{
			Global.frame.showNotification(notify, "mod");
		}
		
	

	}
}