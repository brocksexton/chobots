package com.kavalok.gameplay.windows
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.char.RobotTeam;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.robot.RobotTO;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.messenger.commands.CombatRequestMessage;
	import com.kavalok.messenger.commands.RemoveFromTeamMessage;
	import com.kavalok.messenger.commands.RobotTeamRequestMessage;
	import com.kavalok.robots.Robot;
	import com.kavalok.robots.RobotModel;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.RobotService;
	import com.kavalok.services.RobotServiceNT;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteDecorator;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;

	public class RobotView extends CharChildViewBase
	{
		private var _char:Char;
		private var _view:McCharRobotView;
		private var _model:RobotModel;
		private var _robot:Robot;
		
		private var _bundle:ResourceBundle = Global.resourceBundles.robots;
		private var _inviteEnabled:Boolean;
		private var _loading:LoadingSprite;
		
		public function RobotView(char:Char, inviteEnabled:Boolean)
		{
			_char = char;
			_inviteEnabled = inviteEnabled;
			createView();
			getRobot();
			refresh(false);
			super(_view);
		}
		
		private function createView():void
		{
			_view = new McCharRobotView();
			_view.background.visible = false;
			_view.robotRect.visible = false;
			_view.levelCaption.visible = false;
			_view.levelField.visible = false;
			_view.colorClip.visible = false;
			_view.teamField.visible = false;
			_loading = new LoadingSprite(_view.getBounds(_view));
			_view.addChild(_loading);
			_bundle.registerTextField(_view.levelCaption, 'level');
			
			
			_view.inviteTeamButton.visible = false;
			_view.inviteTeamButton.addEventListener(MouseEvent.CLICK, onInviteTeamClick);
			ToolTips.registerObject(_view.inviteTeamButton, 'inviteToTeam', ResourceBundles.ROBOTS);
			GraphUtils.setBtnEnabled(_view.inviteTeamButton, _inviteEnabled && _char.isOnline);
			
			_view.removeTeamButton.visible = false;
			_view.removeTeamButton.addEventListener(MouseEvent.CLICK, onRemoveTeamClick);
			ToolTips.registerObject(_view.removeTeamButton, 'removeFromTeam', ResourceBundles.ROBOTS);
			
			_view.inviteCombatButton.visible = false;
			_view.inviteCombatButton.addEventListener(MouseEvent.CLICK, onInviteCombatClick);
			ToolTips.registerObject(_view.inviteCombatButton, 'challenge', ResourceBundles.ROBOTS);
			GraphUtils.setBtnEnabled(_view.inviteCombatButton, _inviteEnabled && _char.isOnline);
			
			Global.charManager.robotTeam.refreshEvent.addListener(onTeamRefresh);
		}
		
		override public function destroy():void
		{
			Global.charManager.robotTeam.refreshEvent.removeListener(onTeamRefresh);
			super.destroy();
		}
		
		private function onTeamRefresh():void
		{
			refresh();
		}
		
		private function refresh(checkOwnTeam:Boolean = true):void
		{
			var team:RobotTeam = Global.charManager.robotTeam;
			_view.inviteTeamButton.visible = team.isMine && !team.contains(_char.id);
			_view.removeTeamButton.visible = team.isMine && team.contains(_char.id);
			
			refreshTeam(checkOwnTeam);
		}
		
		private function refreshTeam(checkOwnTeam:Boolean):void
		{
			var teamName:String;
			var teamColor:int;
			var team:RobotTeam = Global.charManager.robotTeam;
			
			if (checkOwnTeam && team.contains(_char.id))
			{
				teamName = team.owner;
				teamColor = team.color;
			}
			else if (!checkOwnTeam || _char.teamName && !(_char.teamName == Global.charManager.charId && !team.contains(_char.id)))
			{
				teamName = _char.teamName;
				teamColor = _char.teamColor;
			}
			
			if (teamName)
			{
				_view.teamField.text = Strings.substitute(_bundle.messages.teamNameFormat, teamName);
				SpriteDecorator.decorateColor(_view.colorClip, teamColor, 0);
			}
				
			_view.teamField.visible = Boolean(teamName);
			_view.colorClip.visible = Boolean(teamName);
		}
		
		private function onInviteTeamClick(e:MouseEvent):void
		{
			if (Global.charManager.robotTeam.isFreeSpace)
			{
				var message:RobotTeamRequestMessage = new RobotTeamRequestMessage();
				new MessageService().sendCommand(_char.userId, message);
				Dialogs.showOkDialog(_bundle.messages.teamRequestSent);
			}
			else
			{
				Dialogs.showOkDialog(_bundle.messages.teamLimit);
			}
		}
		
		private function onRemoveTeamClick(e:MouseEvent):void
		{
			var dialogText:String = Strings.substitute(
				_bundle.messages.removeFromTeamConfirm, _char.id);
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(dialogText);
			dialog.yes.addListener(removeFromTeam);
		}
		
		private function removeFromTeam():void
		{
			Global.isLocked = true;
			new RobotService(onRemoveFromTeam).removeFromTeam(_char.userId);
		}
		
		private function onRemoveFromTeam(result:Boolean):void
		{
			Global.isLocked = false;
			Global.charManager.robotTeam.refresh();
			new MessageService().sendCommand(_char.userId, new RemoveFromTeamMessage());
		}
		
		private function onInviteCombatClick(e:MouseEvent):void
		{
			var robotBundle:ResourceBundle = Global.resourceBundles.robots; 
			
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
			}
			else if (!Global.charManager.hasRobot)
			{
				Dialogs.showOkDialog(robotBundle.messages.haveNotRobot);
			}
			else if (_char.server != Global.loginManager.server)
			{
				Dialogs.showOkDialog(robotBundle.messages.mustBeSameServer)
			}
			else if (Global.charManager.robotTeam.contains(_char.id))
			{
				Dialogs.showOkDialog(Global.resourceBundles.robots.messages.combatNotAllowed);
			}
			else
			{
				var text:String = robotBundle.messages.combatRequest;
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
				dialog.yes.addListener(sendRequest);
			}
		}
		
		private function sendRequest():void
		{
			var command:CombatRequestMessage = new CombatRequestMessage();
			new MessageService().sendCommand(_char.userId, command);
		}
		
		private function getRobot():void
		{
			new RobotServiceNT(onGetRobot).getCharRobot(_char.userId);
		}
		
		private function onGetRobot(result:RobotTO):void
		{
			GraphUtils.detachFromDisplay(_loading);
			if (result)
			{
				_robot = new Robot(result);
				fillView();
				createModel();
			}
		}
		
		private function fillView():void
		{
			_view.levelField.text = String(_robot.level);
			_view.inviteCombatButton.visible = true;
			_view.levelCaption.visible = true;
			_view.levelField.visible = true;
			
			refresh(false);
		}
		
		private function createModel():void
		{
			_model = new RobotModel(_robot);
			_model.readyEvent.addListener(onModelReady);
			_model.updateModel();
		}
		
		private function onModelReady():void
		{
			_view.addChild(_model);
			GraphUtils.fitToObject(_model, _view.robotRect);
		}
		
	}
}