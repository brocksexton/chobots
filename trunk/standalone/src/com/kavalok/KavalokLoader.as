package com.kavalok
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class KavalokLoader extends UIComponent
	{
		private static const WIDTH : uint = 900;
		private static const HEIGHT : uint = 510;
		private static const BACKROUND_Y : int = -4;
		private static const BACKROUND_HEIGHT : int = 518;
		private var _loader:Loader;
		
		private var _background:McBackground = new McBackground();
		private var _border:Sprite;
		
		public function KavalokLoader()
		{
			super();
			addEventListener(FlexEvent.INITIALIZE, onInitialzie);
		}
		
		public function onInitialzie(e:FlexEvent):void
		{
			_border = new Sprite();
			_border.cacheAsBitmap = true;
			_background.cacheAsBitmap = true;
			
			addChild(_background);
			addChild(_border);
			
			var version:String = "1";
			var urlPrefix:String = "http://chobots.net/game/43/";
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.load(new URLRequest(urlPrefix + 'Main.swf?version=' + version));
			width = WIDTH;
			height = HEIGHT;
		} 
		
		private function onLoadComplete(e:Event):void
		{
			addChildAt(_loader.content, 2);
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			trace(e.toString());
		}
	}
}
