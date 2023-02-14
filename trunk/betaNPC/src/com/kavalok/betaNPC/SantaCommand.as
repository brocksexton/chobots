package com.kavalok.betaNPC{	import com.kavalok.quest.findItems.NPCCommand;	import com.kavalok.quest.findItems.QuestStates;	import com.kavalok.gameplay.commands.RetriveStuffByIdCommand;	import com.kavalok.dto.stuff.StuffTypeTO;	import com.kavalok.gameplay.KavalokConstants;	import com.kavalok.gameplay.ResourceSprite;	import com.kavalok.utils.GraphUtils;	import com.kavalok.utils.Maths;	import com.kavalok.utils.SpriteTweaner;		import betaNPC.McBeta;	public class SantaCommand extends NPCCommand	{		private var _betaQuest : Quest;		public var itemId : int = 1641;		public function SantaCommand(quest : Quest)		{			_betaQuest = quest;			super(quest, McBeta);		}				override protected function onNpcActivate():void		{			var state:String = _betaQuest.getState();			var dialog:SantaDialog = new SantaDialog(state);									if (state == QuestStates.QUEST_TASK)			{				new RetriveStuffByIdCommand(itemId, 'Space Dude', Maths.random(0xffffff)).execute();			}			else if (state == QuestStates.NEXT_ITEM)			{							}			else if (state == QuestStates.QUEST_COMPLETE)			{							}			else if (state == QuestStates.IDLE_MESSAGE)			{				var text:String = _betaQuest.bundle.messages[QuestStates.IDLE_MESSAGE];				_npc.showDialog([text]);				dialog = null;			}						if (dialog)				dialog.execute();		}				private function giveItem():void		{			_betaQuest.retriveItem(Quest.ITEM);		}			}}