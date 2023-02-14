package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import com.kavalok.utils.Strings;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.commands.RetriveStuffByIdCommand;
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	
	import com.kavalok.events.EventSender;
	
	public class DialogTokenView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var claimButton:SimpleButton;
		public var codeText:TextField;
		public var _twitText:String;
		private var _ok:EventSender = new EventSender();
		
		public function DialogTokenView(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false)
		{
			super(content || new DialogToken(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = okVisible;
			claimButton.addEventListener(MouseEvent.CLICK, onClaimClick);
	
		
		}
		
		public function get ok():EventSender
		{
			return _ok;
		}

		private function onClaimClick(event:MouseEvent):void
		{
			Global.isLocked = true;
			new AdminService(onTokenClaim).claimToken(codeText.text, Global.charManager.charId);
		}

		private function onTokenClaim(result:String):void
		{
			Global.isLocked = false;
			if (result.indexOf("qee853j_")!= -1)
			{
				var itemId:int = parseInt(result.split("_")[1]);
				var colorId:int = parseInt(result.split("_")[2]);
				new RetriveStuffByIdCommand(itemId, 'Chobots', colorId).execute();
				Dialogs.showOkDialog("You have claimed the code " + codeText.text);
			} else if (result.indexOf("qeeg7tw_") != -1)
			{
				new AddMoneyCommand(parseInt(result.split("_")[1]), "claimed item id: " + result.split("_")[1], false, null, false).execute();
				Dialogs.showOkDialog("You have claimed the code " + codeText.text);
			} else {
				Dialogs.showOkDialog(Global.messages[result]);
			}
		}
		
		protected function onOkClick(event:MouseEvent):void
		{
			hide();
			ok.sendEvent();
		}

			public function get token():String
		{
			 return Strings.trim(codeText.text);
		}
		
	
	}
}