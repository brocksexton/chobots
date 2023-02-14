package com.kavalok.questChopix
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	
	import flash.events.MouseEvent;
	
	public class NPCDialog
	{
		public var onAccept:Function;
		public var onClose:Function;
		
		private var _content:McDialog;
		private var _dialogId:String;
		
		public function NPCDialog(dialodId:String)
		{
			_dialogId = dialodId;
		}
		
		public function execute():void
		{
			var messages:Object = Quest.instance.bundle.messages;
			
			_content = new McDialog();
			_content.imagesClip.gotoAndStop(_dialogId);
			_content.textField.text = messages[_dialogId];
			_content.captionField.text = messages.caption;
			
			if (onAccept != null)
			{
				_content.acceptButton.addEventListener(MouseEvent.CLICK, onAcceptClick);
				Global.resourceBundles.kavalok.registerButton(
					_content.acceptButton, 'accept'); 
			}
			else
			{
				_content.acceptButton.addEventListener(MouseEvent.CLICK, onCloseClick);
				Global.resourceBundles.kavalok.registerButton(
					_content.acceptButton, 'ok'); 
			}
			
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			Dialogs.showDialogWindow(_content);
		}
		
		private function onAcceptClick(e:MouseEvent):void
		{
			Dialogs.hideDialogWindow(_content);
			onAccept();
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			Dialogs.hideDialogWindow(_content);
			
			if (onClose != null)
				onClose();
		}
	}
}