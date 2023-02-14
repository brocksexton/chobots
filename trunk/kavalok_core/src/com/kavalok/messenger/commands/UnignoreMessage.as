package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;

	public class UnignoreMessage extends MessageBase
	{
		override public function show():void
		{
			showInfo(Global.messages.unignore, getText(), closeDialog);
		}
		
		override public function getText():String
		{
			return Strings.substitute(Global.messages.unignoreText, sender); 
		}
		
	}
}