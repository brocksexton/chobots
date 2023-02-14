package com.kavalok.robotCombat.actions
{
	import com.kavalok.Global;
	import com.kavalok.commands.AsincMacroCommand;
	import com.kavalok.commands.IAsincCommand;
	import com.kavalok.robotCombat.CombatPlayer;
	import com.kavalok.robotCombat.CombatSounds;
	import com.kavalok.robotCombat.commands.ShowPointsCommand;
	
	public class CombatAction extends CombatActionBase
	{
		public function CombatAction(source:CombatPlayer, target:CombatPlayer)
		{
			this.source = source;
			this.target = target;
		}
		
		override public function execute():void
		{
			var action:CombatActionBase;
			
			if (result.attackDirection)
				action = new BaseAction();
			else if (result.specialItemId != -1)
				action = new SpecialAction();
			
			if (action)
			{
				action.source = source;
				action.target = target;
				action.completeEvent.addListener(onActionComplete);
				action.execute();
			}
			else
			{
				dispathComplete();
			}
		}
		
		private function onActionComplete(sender:IAsincCommand):void
		{
			var command:AsincMacroCommand = new AsincMacroCommand();
			
			combat.addEnergy(target.robot, -result.damage);
			command.add(new ShowPointsCommand(-result.damage, targetTextPosition));
			
			if (result.repair != 0)
			{
				if (source == combat.myPlayer)
					combat.addEnergy(source.robot, result.repair);
				else
					combat.setEnergy(source.robot, result.energy);
					
				command.add(new ShowPointsCommand(result.repair, sourceTextPosition));
			}
			
			Global.playSound(CombatSounds.DAMAGE);
			command.completeEvent.addListener(onComplete);
			command.execute();
		}
		
		private function onComplete(sender:Object = null):void
		{
			dispathComplete();
		}
		
	}
}