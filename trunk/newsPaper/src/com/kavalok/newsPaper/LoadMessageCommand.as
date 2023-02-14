package com.kavalok.newsPaper
{
	import com.kavalok.interfaces.ICommand;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.services.PaperService;
	import com.kavalok.utils.Strings;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class LoadMessageCommand implements ICommand
	{
		private static const FILE_FORMAT : String = "resources/paperMessages/{0}.{1}.swf";

		private var _newsPage : NewsPage;
		private var _index : uint;
		
		public function LoadMessageCommand(newsPage : NewsPage, index : uint)
		{
			_newsPage = newsPage;
			_index = index;
		}

		public function execute():void
		{
			new PaperService(onGetMessage).getMessage(_index);
			
		}
		
		private function onGetMessage(result : String) : void
		{
			var fileName : String = Strings.substitute(FILE_FORMAT, result, Localiztion.locale);
			var loader : SafeLoader = new SafeLoader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest(fileName));
		}
		
		private function onLoadComplete(event : Event) : void
		{
			var loaderInfo : LoaderInfo = LoaderInfo(event.target);
			_newsPage.loadingText.visible = false;
			_newsPage.addChild(loaderInfo.content);
		}
		
	}
}