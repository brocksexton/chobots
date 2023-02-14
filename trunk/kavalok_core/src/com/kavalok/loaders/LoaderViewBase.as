package com.kavalok.loaders
{
	import com.kavalok.events.EventSender;
	
	import flash.display.Sprite;

	public class LoaderViewBase implements ILoaderView
	{
		private var _readyEvent:EventSender = new EventSender();
		public function LoaderViewBase()
		{
		}

		public function get ready():Boolean
		{
			return true;
		}
		
		public function get readyEvent():EventSender
		{
			return _readyEvent;
		}
		
		public function set percent(value:int):void
		{
		}
		
		public function set text(value:String):void
		{
		}
		
		public function get content():Sprite
		{
			return null;
		}
		
	}
}