package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;

	public class IgnoreMessage extends MessageBase
	{
		
		private var _doIgnore : Boolean;
		
		override public function show():void
		{
			showInfo(Global.messages.ignore, getText(), closeDialog);
		}
		
		override public function getText():String
		{
			return Strings.substitute(Global.messages.ignoreText, sender);
		}
	}
}