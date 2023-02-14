package com.kavalok.missionNichos
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.RetriveStuffCommand;
	import com.kavalok.localization.Localiztion;
	
	import flash.events.MouseEvent;

	public class NPCDialog
	{
		public var onAccept:Function;
		public var onClose:Function;

		private var _content:McDialog;
		private var messages:Object = Localiztion.getBundle("missionNichos").messages;
		private var _alreadyClicked:Boolean;
		private var _missionPassed : Boolean
		

		public function NPCDialog(missionPassed : Boolean, alreadyClicked : Boolean)
		{
			_missionPassed = missionPassed;
			_alreadyClicked = alreadyClicked;
		}

		public function execute():void
		{
			
			_content=new McDialog();

			if(!_missionPassed){
				_content.textField.text=messages.helpMe;
			}else if(!_alreadyClicked){
				retriveItem();
				_content.textField.text=messages.missionComplete;
			}else {
				_content.textField.text=messages.missionAlreadyCompleted;
			}


			_content.captionField.text=messages.caption;

			_content.acceptButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			Global.resourceBundles.kavalok.registerButton(_content.acceptButton, 'ok');

			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			Dialogs.showDialogWindow(_content);
		}

		private function onCloseClick(e:MouseEvent):void
		{
			Dialogs.hideDialogWindow(_content);

			if (onClose != null)
				onClose();
		}
		
		public function retriveItem():void
		{
			var sender:String = messages.npcName;
			new RetriveStuffCommand("mask_nichos", sender).execute();
		}
		
	}
}

