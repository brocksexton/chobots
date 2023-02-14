package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dialogs.McReportUser;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.services.AdminService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ReportCommand extends CharCommandBase
	{
		static private const CHAT_HISTORY_LENGTH:int = 50;
		
		private var _content:McReportUser;
		private var _checkBoxes:Array = [];
		
		override public function execute():void
		{
			createContent();
			Dialogs.showOkDialog(null, true, _content);
			
			_content.sendButton.addEventListener(MouseEvent.CLICK, onSendClick);
			_content.warnButton.addEventListener(MouseEvent.CLICK, onWarnClick);
			_content.warnButton.visible = false;
			
			refresh();
		}
		
		private function onWarnClick(e:MouseEvent):void
		{
			var checkedButons:Array = getCheckedButtons();
			var warnText:String = new String();
			for each (var button:StateButton in checkedButons)
			{
				warnText += Global.messages[button.content.name] + '#';
			}
			
			//new AdminService(sendWarn).sendAgentRules(char.userId, warnText);

		}

		private function createContent():void
		{
			_content = new McReportUser();
			
			for (var i:int = 0; i < _content.checkBoxes.numChildren; i++)
			{
				var clip:MovieClip = _content.checkBoxes.getChildAt(i) as MovieClip;
				
				if (!clip)
					continue;
				
				var checkBox:StateButton = new StateButton(clip);
				checkBox.stateEvent.addListener(refresh);
				
				_checkBoxes.push(checkBox);
			}
		}
		
		private function refresh(sender:Object = null):void
		{
			var sendEnabled:Boolean = getCheckedButtons().length > 0;
			GraphUtils.setBtnEnabled(_content.sendButton, sendEnabled);
		}
		
		private function onSendClick(e:MouseEvent):void
		{
			Dialogs.hideDialogWindow(_content);
			Global.isLocked = true;
			new AdminService(onReportResult).reportUser(char.userId, getReportText(char.id));
		}
		
		private function onReportResult(result:Object):void
		{
			Global.isLocked = false;
			Dialogs.showOkDialog(Global.messages.reportReceived);
		}

			private function sendWarn(result:Object = null):void
		{
			Global.isLocked = false;
			Dialogs.showOkDialog("The user has been warned successfully.");
		}
		
		private function getReportText(login:String):String
		{
			var text:String = '';
			var checkedButons:Array = getCheckedButtons();
			
			text += 'This user was reported by: ' + Global.charManager.charId + '\n' + "Date: " + Global.getPanelDate() + "\n\n";
			
			for each (var button:StateButton in checkedButons)
			{
				text += Global.messages[button.content.name] + '\n';
			}
			
			var chatHistory:Array = Global.notifications.stack;
			if (chatHistory.length == 0)
				return ""; //Ticket #3549
			var reportedLoginPresent:Boolean = false;
			for each (var notification:Notification in chatHistory)
			{
				text += notification.fromLogin + ': ' + notification.message + '\n';
				reportedLoginPresent = reportedLoginPresent || (notification.fromLogin == login);
			}
			if (!reportedLoginPresent)
				text = ""; //Ticket #3549
			
			return text;
		}
		
		private function getCheckedButtons():Array
		{
			return Arrays.getByRequirement(_checkBoxes, new PropertyCompareRequirement('state', 2));
		}
	
	}
}