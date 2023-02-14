package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.modules.IQuestModule;
	
	import flash.net.URLRequest;
	
	public class LoadQuestCommand extends ServerCommandBase
	{
		private var _loader:SafeLoader;
		
		override public function execute():void
		{
			var moduleName:String = String(parameter);
			
			if (moduleName in Global.quests)
				return;
				
			_loader = new SafeLoader();
			_loader.load(new URLRequest(URLHelper.moduleUrl(moduleName)));
			_loader.completeEvent.addListener(onLoadComplete);
			
			Global.quests[moduleName] = _loader;
		}
		
		private function onLoadComplete():void
		{
			IQuestModule(_loader.content).initialize();
		}

	}
}