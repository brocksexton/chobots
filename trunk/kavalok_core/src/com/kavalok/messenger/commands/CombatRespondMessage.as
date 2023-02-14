package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.robots.CombatParameters;
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;
	
	public class CombatRespondMessage extends MessageBase
	{
		public var level:int = Global.charManager.robot.level;
		
		override public function execute():void
		{
			if (!messageExists())
				super.execute();
		}
		
		override public function getIcon():Class
		{
			return McMsgCombatIcon;
		}
		
		override public function show():void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(getText());
			dialog.yes.addListener(applyCombat);
		}
		
		override public function getText():String
		{
			return Strings.substitute( 
				Global.resourceBundles.robots.messages.combatRespondMessage,
				sender,
				String(level));
		}
		
		protected function applyCombat(e:Event = null):void
		{
			if (Global.charManager.robotTeam.contains(sender))
			{
				Dialogs.showOkDialog(Global.resourceBundles.robots.messages.combatNotAllowed);
			}
			else
			{
				var parameters:CombatParameters = new CombatParameters(senderUserId);
				Global.moduleManager.loadModule(Modules.ROBOT_COMBAT, parameters);
			}
		}
	}
}