package com.kavalok.robotCombat.actions
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.commands.AsincMacroCommand;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.robotCombat.CombatSounds;
	import com.kavalok.robotCombat.commands.ShowHintCommand;
	import com.kavalok.robots.RobotModels;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.MoviePlayer;
	import com.kavalok.utils.Timers;
	
	import flash.display.MovieClip;
	
	public class SpecialAction extends CombatActionBase
	{
		private var _action:AsincMacroCommand;
		
		public function SpecialAction()
		{
			super();
		}
		
		override public function execute():void
		{
			createAnimation();
			Global.playSound(CombatSounds.SPECIAL_ITEM);
			new ShowHintCommand(item.localizedName, sourceTextPosition).execute();
			Timers.callAfter(createTargetModel, 1000);
		}
		
		private function createTargetModel():void
		{
			if (!result.affected)
			{
				Global.playSound(CombatSounds.MISS);
				targetModel.setModel(RobotModels.GROUPING);
				new MoviePlayer(targetModel.content).play();
				new ShowHintCommand(bundle.messages.resultMiss, targetTextPosition).execute();
			}
			else if (result.damage > 0)
			{
				targetModel.setModel(RobotModels.DAMAGE_TOP);
				new MoviePlayer(targetModel.content).play();
			}
		}
		
		private function createAnimation():void
		{
			var clip:MovieClip = createClip();
			mainView.attachAnimation(clip);
			
			if (source != combat.myPlayer)
			{
				clip.scaleX = -1;
				clip.x = KavalokConstants.SCREEN_WIDTH;
			}
			
			var moviePlayer:MoviePlayer = new MoviePlayer(clip);
			moviePlayer.completeEvent.addListener(onComplete);
			moviePlayer.execute();
		}
		
		private function onComplete(sender:MoviePlayer):void
		{
			GraphUtils.detachFromDisplay(sender.clip);
			dispathComplete();
		}
		
		private function createClip():MovieClip
		{
			var url:String = URLHelper.robotItemURL(item.name); 
			return Global.classLibrary.getInstance(url, 'McAnimation') as MovieClip;
		}
		
		public function get item():RobotItemTO
		{
			 return source.robot.getItem(result.specialItemId);
		}
		
	}
}