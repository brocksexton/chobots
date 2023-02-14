package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	
	import flash.events.Event;

	public class CitizenMembershipEndMessage extends MessageBase
	{

		private var _messageId:String;
		private var _messageCaptionId:String;

		public function CitizenMembershipEndMessage(messageCaptionId:String, messageId:String)
		{
			_messageCaptionId=messageCaptionId;
			_messageId=messageId;
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}

		override public function show():void
		{
			showConfirmation(Global.messages[_messageCaptionId], Global.messages[_messageId], onMembershipAccept);
		}

		private function onMembershipAccept(event : Event):void
		{
			closeDialog();
			if (!Global.charManager.isCitizen)
				Dialogs.showBuyAccountDialog("renewMessage");
			else
			{
				Dialogs.showCitizenStatusDialog("renewMessage", true);
			}
		}


	}
}



