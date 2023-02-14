package com.kavalok.loaders
{
	import com.kavalok.events.EventSender;
	
	import flash.display.Sprite;
	
	public interface ILoaderView
	{
		function get ready():Boolean;
		function get readyEvent():EventSender;
		function set percent(value:int):void;
		function set text(value:String):void;
		function get content():Sprite;
	}
}