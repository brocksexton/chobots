package
{
	import com.kavalok.modules.IQuestModule;
	import com.kavalok.questNichos.Quest;
	
	import flash.display.Sprite;
	
	public class QuestNichos extends Sprite implements IQuestModule
	{
		private var _quest:Quest
		
		public function initialize():void
		{
			_quest = new Quest();
		}
		
		public function unload():void
		{
			_quest.destroy();
		}
	}
}
