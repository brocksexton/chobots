package com.kavalok.quest
{
	import com.kavalok.modules.IQuestModule;
	
	import flash.display.Sprite;

	public class LocationQuestModuleBase extends Sprite implements IQuestModule
	{
		private var _quest:LocationQuestBase;
		private var _type:Class
		
		public function LocationQuestModuleBase(type : Class)
		{
			super();
			_type = type;
		}

		public function initialize():void
		{
			_quest = new _type();
		}
		
		public function unload():void
		{
			_quest.destroy();
		}
	}
}