package
{
	import com.kavalok.modules.IQuestModule;
	import com.kavalok.questAcademy.Quest;
	
	import flash.display.Sprite;
	
	public class QuestAcademy extends Sprite implements IQuestModule
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
