package common.loaders
{
	import common.commands.ICancelableCommand;
	import common.events.EventSender;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class DataLoader implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(this);
		
		private var _loader:URLLoader;
		private var _url:String;
		private var _errorMessage:String;
		private var _success:Boolean = false;
		
		public function DataLoader(url:String)
		{
			_url = url;
		}
		
		public function execute():void
		{
			_loader = new flash.net.URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.load(new URLRequest(_url));
		}
		
		public function cancel():void
		{
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			
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
			_success = true;
			_completeEvent.sendEvent();
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			_errorMessage = e.text;
			_completeEvent.sendEvent();
			trace(_errorMessage);
		}
		
		public function get data():*
		{
			return _loader.data;
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
		public function get errorMessage():String { return _errorMessage; }
		
		public function get url():String { return _url; }
		
		public function get success():Boolean { return _success; }
	}
	
}