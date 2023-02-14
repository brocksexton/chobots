package com.kavalok.loaders
{
	import flash.net.URLRequest;
	
	import com.kavalok.interfaces.ICommand;

	public class LoadURLCommand implements ICommand
	{
		private var _onComplete:Function;
		private var _url:String;
		private var _loader:SafeURLLoader;
		
		public function LoadURLCommand(url:String, onComplete:Function)
		{
			_url = url;
			_onComplete = onComplete;
		}

		public function execute():void
		{
			_loader = new SafeURLLoader();
			_loader.completeEvent.addListener(onLoadComplete);
			_loader.errorEvent.addListener(onLoadError);
			_loader.load(new URLRequest(_url));
		}
		
		private function onLoadComplete():void
		{
			_onComplete(_loader.data);
		}
		
		private function onLoadError():void
		{
			_onComplete(null);
		}
	}
}