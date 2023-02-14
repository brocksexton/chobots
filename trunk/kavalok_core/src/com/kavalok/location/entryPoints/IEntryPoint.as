package com.kavalok.location.entryPoints
{
	import com.kavalok.events.EventSender;
	import com.kavalok.location.LocationBase;
	
	import flash.geom.Point;
	
	public interface IEntryPoint
	{
		function get charPosition():Point 
		function get activateEvent():EventSender;
		
		function goIn():void;
		function goOut():void; 
		function destroy():void; 
	}
}