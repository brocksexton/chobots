package com.kavalok.commands.resources
{
	import com.kavalok.Global;
	import com.kavalok.commands.ICancelableCommand;
	import com.kavalok.events.EventSender;
	import com.kavalok.loaders.LocationLoaderView;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.net.URLRequest;

	public class LoadResourceCommand implements ICancelableCommand
	{
		private var _url:String;
		private var _loader:SafeLoader;
		private var _view:LocationLoaderView;
		
		private var _completeEvent:EventSender = new EventSender(LoadResourceCommand);
		
		public function LoadResourceCommand(url:String)
		{
			_url = url;
		}

		public function execute():void
		{
			_view = new LocationLoaderView();
			_loader = new SafeLoader(_view);
			_loader.completeEvent.addListener(onLoadComplete);
			_loader.load(new URLRequest(_url));
			Global.root.addChild(_view.content);
		}
		
		private function onLoadComplete():void
		{
			GraphUtils.detachFromDisplay(_view.content);
			_completeEvent.sendEvent(this);
		}
		
		public function cancel():void
		{
			GraphUtils.detachFromDisplay(_view.content);
			_loader.cancelLoading();
		}
		
		public function get loader():SafeLoader
		{
			 return _loader;
		}
		
		public function get content():DisplayObject
		{
			 return _loader.content;
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
	}
}