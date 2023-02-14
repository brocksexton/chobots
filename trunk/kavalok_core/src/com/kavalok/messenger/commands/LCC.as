package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.messenger.McInfoMessage;
	import com.kavalok.messenger.McYesNoMessage;
	import com.kavalok.remoting.RemoteCommand;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	//location chat command
	public class LCC extends RemoteCommand
	{
		public var s:String;
		public var si:Number;
		public var l:String;
		public var m:String;
		
		protected var _dialog:Sprite;
		
		override public function execute():void
		{
			Global.notifications.receiveChat(s, si, m);
		}
		
	}
}