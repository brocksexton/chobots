package com.kavalok.modules
{
	import com.kavalok.events.EventSender;
	
	public interface IModule
	{
		function initialize():void;
		
		function closeModule():void;
		
		function get destroyEvent():EventSender;
		
		function set parameters(value:Object):void;
		
		function get parameters():Object;
		
		function get readyEvent():EventSender;
	}
}
