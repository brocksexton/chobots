package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.Strings;
	import com.kavalok.services.CharService;
	
	public class RemoveFriendCommand  extends CharCommandBase
	{
		override public function execute():void
		{
			var text:String = Strings.substitute(Global.messages.removeFriendConf, char.id);
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
			dialog.yes.addListener(removeFriend);
		}

		private function removeFriend():void
		{
			new CharService(onDeBffd).removeBestFriend(char.userId);
			Global.charManager.friends.removeFriends([char.userId]);
			
		}

		private function onDeBffd(result:String):void
		{

		}
	}
}