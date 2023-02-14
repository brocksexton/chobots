package com.kavalok.gameplay.tips
{
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.loaders.SafeURLLoader;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.TaskCounter;
	
	import flash.net.URLRequest;
	
	public class LoadTipCommand
	{
		static private const XML_URL:String = 'resources/tips/tip{0}.{1}.xml';
		static private const IMG_URL:String = 'resources/tips/tip{0}.jpg';
		
		private var _xmlLoader:SafeURLLoader;
		private var _imgLoader:SafeLoader;
		private var _task:TaskCounter;
		private var _tipId:int;
		private var _tip:Tip;
		private var _completeHandler:Function;
		
		public function LoadTipCommand(tipId:int, completeHandler:Function)
		{
			_tipId = tipId;
			_completeHandler = completeHandler;
		}
		
		public function execute():void
		{
			_tip = new Tip();
			
			_task = new TaskCounter(2);
			_task.completeEvent.addListener(onTaskComplete);
			
			var xmlURL:String = Strings.substitute(XML_URL, _tipId, Localiztion.locale);
			_xmlLoader = new SafeURLLoader();
			_xmlLoader.completeEvent.addListener(onXmlLoaded);
			_xmlLoader.errorEvent.addListener(_task.completeTask);
			_xmlLoader.load(new URLRequest(xmlURL));
			
			var imgURL:String = Strings.substitute(IMG_URL, _tipId);
			_imgLoader = new SafeLoader();
			_imgLoader.completeEvent.addListener(onImgLoaded);
			_imgLoader.errorEvent.addListener(_task.completeTask);
			
			_imgLoader.load(new URLRequest(imgURL)); 
		}
		
		private function onXmlLoaded():void
		{
			var xml:XML = new XML(_xmlLoader.data);
			_tip.title = xml.title;
			_tip.text = xml.text;
			
			_task.completeTask();
		}
		
		private function onImgLoaded():void
		{
			_tip.picture = _imgLoader.content;
			_task.completeTask();
		}
		
		private function onTaskComplete():void
		{
			_completeHandler(_tip);
		}
		
	}
}