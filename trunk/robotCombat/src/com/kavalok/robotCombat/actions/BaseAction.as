package com.kavalok.robotCombat.actions
{
	import com.kavalok.Global;
	import com.kavalok.commands.AsincMacroCommand;
	import com.kavalok.robotCombat.CombatSounds;
	import com.kavalok.robotCombat.commands.ShowHintCommand;
	import com.kavalok.robots.CombatConstants;
	import com.kavalok.robots.RobotModels;
	import com.kavalok.utils.MoviePlayer;
	
	import flash.events.Event;
	
	public class BaseAction extends CombatActionBase
	{
		private var _action:AsincMacroCommand;
		
		public function BaseAction()
		{
			super();
		}
		
		override public function execute():void
		{
			showSourceModel();
			createAction();
		}
		
		private function showSourceModel():void
		{
			var modelName:String = RobotModels.getAttackModel(result.attackDirection);
			sourceModel.setModel(modelName);
			
			sourceModel.content.addEventListener(Event.COMPLETE, onSourceHit);
			
			var textMap:Object = {};
			textMap[CombatConstants.TOP] = bundle.messages.attackTop;
			textMap[CombatConstants.MIDDLE] = bundle.messages.attackMiddle;
			textMap[CombatConstants.BOTTOM] = bundle.messages.attackBottom;
			var text:String = textMap[result.attackDirection];
			new ShowHintCommand(text, sourceTextPosition).execute();
		}
		
		private function createAction():void
		{
			_action = new AsincMacroCommand();
			_action.add(new MoviePlayer(sourceModel.content));
			_action.completeEvent.addListener(onComplete);
			_action.execute();
		}
		
		private function onSourceHit(e:Event):void
		{
			showTargetModel();
			_action.add(new MoviePlayer(targetModel.content));
		}
		
		private function showTargetModel():void
		{
			var modelName:String;
			var hint:String = null;
			
			if (result.blocked)
			{
				hint = bundle.messages.resultBlock;
				modelName = RobotModels.BLOCK;
				Global.playSound(CombatSounds.BLOCK);
			}
			else if (result.affected)
			{
				modelName = RobotModels.getDemageModel(result.attackDirection);
				Global.playSound(CombatSounds.KICK);
			}
			else
			{
				hint = bundle.messages.resultMiss;
				modelName = RobotModels.GROUPING;
				Global.playSound(CombatSounds.MISS);
			}
			
			if (hint)
				new ShowHintCommand(hint, targetTextPosition).execute();
			
			targetModel.setModel(modelName);
		}
		
		private function onComplete(sender:AsincMacroCommand):void
		{
			dispathComplete();
		}
		
	}
}