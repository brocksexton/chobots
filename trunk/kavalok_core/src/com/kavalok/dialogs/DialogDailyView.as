package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.commands.RetriveStuffByIdCommand;
	import com.kavalok.remoting.commands.UpdateMoneyCommand;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.MagicServiceNT;
	import com.kavalok.utils.Maths;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class DialogDailyView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var text2field:TextField;
		public var itemClip:MovieClip;
		public var _bugsNum:int;
		public var _itemId:int;
		public var _itemName:String;
		public var _stuff : ResourceSprite;
		public var lolSprite : MovieClip;
		private var _ok:EventSender = new EventSender();
		
		public function DialogDailyView(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false)
		{
			super(content || new DialogOk(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = okVisible;
			Global.isLocked = true;
			new AdminService(onGetData).getSavedData();
		
		}

		public function onGetData(result:String):void
		{
			
			if(result.indexOf("item") != -1){
				var itemid2:String = result.split("_")[1];
				_itemId = parseInt(itemid2.split("_")[0]);
				_itemName = result.split("_")[2];
				goItem();
			} else if (result.indexOf("bugs") != -1){
				_bugsNum = parseInt(result.split("_")[1]);
				goBugs();
			} 
		}

		public function goItem():void
		{
			itemClip.gotoAndStop(3);
			text2field.text = "Welcome to Chobots. You've received an item for logging in today! Come back tomorrow for more.";
			new RetriveStuffByIdCommand(_itemId, "Daily Reward", Maths.random(0xFFFFFF)).execute();
			Global.retrievedItem = true;
			new MagicServiceNT().setLastDaily();
			Global.isLocked = false;

			var info:StuffTypeTO = new StuffTypeTO();
			info.fileName = _itemName;
			info.id = _itemId;
			info.type = "C";
			_stuff = info.createModel();
			_stuff.loadContent();
		//	_stuff.y = 153.25;
		//	_stuff.x = 316.20;
			itemClip.addChild(_stuff);
		}

		public function goBugs():void
		{
			itemClip.gotoAndStop(2);
			text2field.text = "Welcome to Chobots! You've received " + _bugsNum + " bugs for logging in. Come back tomorrow for more!";
			new AddMoneyCommand(_bugsNum, "Daily Login", false).execute();
			Global.retrievedItem = true;
			Global.isLocked = false;
			new MagicServiceNT().setLastDaily();
		}
		
		public function get ok():EventSender
		{
			return _ok;
		}
		
		protected function onOkClick(event:MouseEvent):void
		{
			hide();
			ok.sendEvent();
		}
	
	}
}