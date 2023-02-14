package com.kavalok.loaders
{
	import com.kavalok.events.EventSender;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class ViewLoader extends Loader
	{
		private var _url:String;
		private var _completeEvent:EventSender = new EventSender();
		private var _errorEvent:EventSender = new EventSender();
		private var _view:ILoaderView;

		public function ViewLoader(view : ILoaderView)
		{
			super();
			_view = view;
			
			contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadFault);
		//	_view.loadBar.loading.scaleX=0;
			
			if (_view)
				contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
				
				
		}
		
		override public function load(request:URLRequest, context:LoaderContext=null):void
		{
			_url = request.url;
			super.load(request, context);
		}
		
		public function cancelLoading():void
		{
			try
			{
				close();
			}
			catch (e:Error)
			{
			}
			
			contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFault);
		}
		
		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}
		
		public function get errorEvent():EventSender
		{
			return _errorEvent;
		}

		protected function onLoadComplete(e:Event):void
		{
			_completeEvent.sendEvent();
		}
		
		protected function onProgress(e:ProgressEvent):void
		{
		//	var percLoaded:Number = (e.bytesLoaded / e.bytesTotal);
		//	_view.loadBar.loading.scaleX = percLoaded;
			_view.percent = e.bytesLoaded / e.bytesTotal * 100;
		}
		
		protected function onLoadFault(e:IOErrorEvent):void
		{
			_errorEvent.sendEvent();
			trace('File not found: ' + _url);
		}
	}
}