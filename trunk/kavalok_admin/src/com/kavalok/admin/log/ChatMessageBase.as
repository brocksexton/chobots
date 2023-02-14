package com.kavalok.admin.log
{
	import com.kavalok.services.AdminService;
	import com.kavalok.admin.log.data.AdminRemoteObject;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.Alert;
	import mx.controls.TextArea;

	public class ChatMessageBase extends VBox
	{
		[Bindable]
		public var messageTextArea : TextArea;
		private var _remoteObject : AdminRemoteObject = new AdminRemoteObject();
		[Bindable] protected var scrollable : Boolean = true;
		
		public function ChatMessageBase()
		{
			super();
			
			_remoteObject.chatMessageEvent.addListener(onChatMessage);


		}
		public function onClearClick(e:MouseEvent):void
		{
			messageTextArea.htmlText = "";
		}
		private function onChatMessage(lol:Object = null):void
		{
			try {
			var msgText:String = "<b>" + lol.charId + "</b> " + "(" + lol.sharedObjId + "): " + lol.message;
			messageTextArea.htmlText = messageTextArea.htmlText != "" ? messageTextArea.htmlText + "</br>" + msgText : msgText;
			
			doScroll();
		} catch (e:Error){
			trace("Error caught");
		}

		}

		private function doScroll():void
		{
				if(scrollable)
			messageTextArea.verticalScrollPosition = messageTextArea.maxVerticalScrollPosition;
		}
		
	}
}