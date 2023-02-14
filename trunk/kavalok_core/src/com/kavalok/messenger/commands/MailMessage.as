package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.controls.TextScroller;
	import com.kavalok.messenger.McMailMessage;
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;
	
	public class MailMessage extends MessageBase
	{
		private var _scroller:TextScroller;
		
		override public function show():void
		{
			var view:McMailMessage  = new McMailMessage();
			view.captionField.text = String(getCaption());
			view.messageField.text = String(text);
			_scroller = new TextScroller(view.scroller, view.messageField);
			
			Global.resourceBundles.kavalok.registerButton(view.replyButton, 'reply');
			view.closeButton.addEventListener(MouseEvent.CLICK, closeDialog);
			view.replyButton.addEventListener(MouseEvent.CLICK, onReply);
			view.replyButton.visible = Global.notifications.chatEnabled && sender != null && sender != "UTM20";
			
			showDialog(view); 
		}
		
		private function onReply(e:Object = null):void
		{
			closeDialog();
			new SendMessageCommand([senderUserId]).execute();
		}
	}
}