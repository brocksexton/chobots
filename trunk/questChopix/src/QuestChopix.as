package
{
	import com.kavalok.modules.IQuestModule;
	import com.kavalok.questChopix.Quest;
	
	import flash.display.Sprite;
	
	public class QuestChopix extends Sprite implements IQuestModule
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
