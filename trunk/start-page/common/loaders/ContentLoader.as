package common.loaders
{
	import common.commands.ICancelableCommand;
	import common.events.EventSender;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class ContentLoader implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(this);
		
		private var _loader:Loader;
		private var _url:String;
		private var _errorMessage:String;
		
		public function ContentLoader(url:String)
		{
			_url = url;
		}
		
		public function execute():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.load(new URLRequest(_url));
		}
		
		public function cancel():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
			}
		}
		
		private function onLoadComplete(e:Event):void
		{
			_completeEvent.sendEvent();
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			_errorMessage = e.text;
			_completeEvent.sendEvent();
		}
		
		public function get content():DisplayObject
		{
			return _loader.content;
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
		public function get errorMessage():String { return _errorMessage; }
		
		public function get url():String { return _url; }
	}
	
}