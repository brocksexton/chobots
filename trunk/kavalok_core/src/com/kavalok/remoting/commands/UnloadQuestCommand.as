package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.modules.IQuestModule;
	
	import flash.display.Loader;
	
	public class UnloadQuestCommand extends ServerCommandBase
	{
		override public function execute():void
		{
			var moduleName:String = String(parameter);
			
			if (moduleName in Global.quests)
			{
				var loader:SafeLoader = SafeLoader(Global.quests[moduleName]);
				loader.cancelLoading();
				
				var module:IQuestModule = loader.content as IQuestModule;
				
				if (module)
					module.unload();
				
				delete Global.quests[moduleName];
			}
		}
	
	}
}