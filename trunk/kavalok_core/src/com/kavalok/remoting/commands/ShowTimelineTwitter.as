package com.kavalok.remoting.commands{	import com.kavalok.dialogs.Dialogs;	import com.kavalok.remoting.commands.ServerCommandBase;	import com.kavalok.Global;		public class ShowTimelineTwitter extends ServerCommandBase	{				public function ShowTimelineTwitter()		{			trace("show timeline instanted result");		}				override public function execute():void		{			trace("hai");			Global.isLocked = false;			var text:String = String(parameter);			Dialogs.showTwitterTimelineDialog(text, null);		}		}}