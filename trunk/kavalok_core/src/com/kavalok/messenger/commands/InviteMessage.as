package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;

	public class InviteMessage extends MessageBase
	{
		override public function show():void
		{
			if (Global.charManager.isFriendsFull)
			{
				Dialogs.showOkDialog(Global.messages.friendsListFull);
			}
			else
			{
				showConfirmation(Global.messages.invite,
					getText(), sendRequest, sendCancel, 'yes', 'no');
			}
		}
		
		override public function getText():String
		{
			return Strings.substitute(Global.messages.inviteText, sender); 
		}
		
		override public function getIcon():Class
		{
			return McMsgFriendsIcon;
		}
		
		override public function execute():void
		{
			if (Global.charManager.isFriendsFull)
			{
				new MessageService().sendCommand(senderUserId, new FriendListFull());
			}
			else
			{
				var isIgnored:Boolean = Global.charManager.ignores.contains(sender); 
				if (!isIgnored && !messageExists())
					super.execute();
			}
		}
		
		private function sendRequest(e:Event):void
		{
			Global.charManager.friends.addFriend(senderUserId);
			new MessageService().sendCommand(senderUserId, new AddFriendMessage(), true);
			closeDialog();
		}
		
		private function sendCancel(e:Event):void
		{
			//new MessageService().sendCommand(sender, new CancelFriendMessage());
			closeDialog();
		}
	}
}