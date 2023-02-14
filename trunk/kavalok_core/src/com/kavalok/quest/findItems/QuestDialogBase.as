package com.kavalok.quest.findItems
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class QuestDialogBase
	{
		public var onAccept:Function;
		public var onClose:Function;
		
		private var _type:Class;
		protected var _content:MovieClip;
		protected var _dialogId:String;
		protected var _bundle:ResourceBundle;

		public function QuestDialogBase(type : Class, bundleId : String, dialogId : String)
		{
			_type = type;
			_dialogId = dialogId;
			_bundle = Localiztion.getBundle(bundleId);
		}

		public function execute():void
		{
			_content = new _type();
			_content.imagesClip.gotoAndStop(_dialogId);
			_content.textField.text = _bundle.getMessage(_dialogId);
			_content.captionField.text = _bundle.getMessage("caption");
			
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