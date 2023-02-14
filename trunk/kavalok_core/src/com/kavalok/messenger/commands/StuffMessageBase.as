package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.char.Stuffs;
	import com.kavalok.utils.Strings;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.messenger.McPresentWindow;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class StuffMessageBase extends MessageBase
	{
		public var itemId:int;
		
		private var _bundle:ResourceBundle = Global.resourceBundles.kavalok;
		private var _item:StuffItemLightTO;
		
		public function StuffMessageBase():void
		{
		}
		
		/*override public function execute():void
		{
			sender = "";
		}*/
		
		private function onGetItem(result:StuffItemLightTO):void
		{
			Global.charManager.stuffs.addItem(result)
			_item = Global.charManager.stuffs.getById(itemId);
			if (_item)
				showStuff(sender, getText());
		}
		
		override public function getText():String
		{
			return Global.messages.giftMessage;
		}
		
		override public function getIcon():Class
		{
			return McMsgStuffIcon;
		}
		
		override public function show():void
		{
			new StuffServiceNT(onGetItem).getItem(itemId);
		}
		
		private function onUseClick(e:MouseEvent):void
		{
			if (_item.premium && !Global.charManager.isCitizen && _item.type != StuffTypes.STUFF)
			{
				new CitizenWarningCommand("premiumClothes", null).execute();
			}
			else if (_item.type == StuffTypes.PLAYERCARD)
			{
				Global.charManager.playerCard = _item;
			}
			else
			{
				stuffs.useItem(_item);
			}
			
			closeDialog();
			_item = null;
		}
		
		private function onTwitClick(e:MouseEvent):void
		{
			new AdminService().sendTweet(Global.charManager.userId, Global.charManager.accessToken, Global.charManager.accessTokenSecret, "Yay, I've just received an item on @Chobots!");
		}
		
		private function onSellClick(e:MouseEvent):void
		{
			if (_item.shopName == 'shopItems')
			{
				Dialogs.showOkDialog("You cannot sell items from bought with Emeralds");
			} else {
				var text:String = Strings.substitute(Global.messages.recycleWarning, _item.backPrice);
				if(_item.type == StuffTypes.FISH) {
					text = Strings.substitute(Global.messages.recycleWarning, _item.price);
				}
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
				dialog.yes.addListener(doRecycle);
				closeDialog();
			}
		}
		
		private function doRecycle():void
		{
			new AdminService(trashVerified).verifyItemOwner(_item.id);
		}
		
		public function trashVerified(val:Boolean):void
		{
			if(val){
				if(_item.type == StuffTypes.FISH) {
					new AddMoneyCommand(_item.price, "recycle " + _item.fileName, false, null, false).execute();
				} else {
					new AddMoneyCommand(_item.backPrice, "recycle " + _item.fileName, false, null, false).execute();
				}
				Global.charManager.stuffs.removeItem(_item);
			}
		}
		
		protected function showStuff(
			caption:String,
			text:String,
			onClose:Function = null):void
		{
			//-- create window
			var view:McPresentWindow  = new McPresentWindow();
			view.captionField.text = String(caption);
			view.messageField.text = String(text);
			
			view.closeButton.addEventListener(MouseEvent.CLICK, closeDialog);
			view.useButton.addEventListener(MouseEvent.CLICK, onUseClick);
			view.sellButton.addEventListener(MouseEvent.CLICK, onSellClick);
			
		//	if (Global.charManager.accessToken != "notoken"){
		//		view.twitButton.visible = true;
		//	} else {
			//	view.twitButton.visible = false;
		//	}
			
		//	view.twitButton.addEventListener(MouseEvent.CLICK, onTwitClick);
			view.sellButton.visible = false;
			if (_item.type == StuffTypes.CLOTHES)
			{
				view.sellButton.visible = true;
				_bundle.registerButton(view.useButton, 'giftClothesUse');
				_bundle.registerButton(view.closeButton, 'giftClothesPut');
				_bundle.registerButton(view.sellButton, 'Sell item');
			}
			else if (_item.type == StuffTypes.FURNITURE)
			{
				view.useButton.visible = false;
				_bundle.registerButton(view.closeButton, 'ok');
			}
			else
			{
				_bundle.registerButton(view.useButton, 'giftStuffUse');
				_bundle.registerButton(view.closeButton, 'giftStuffPut');
			}
				 
			
			if(_item.type == StuffTypes.FISH)
			{
				view.useButton.visible = false;
				view.sellButton.visible = true;
				_bundle.registerButton(view.sellButton, 'Sell item');
				view.captionField.text = "Caught a Fish";
				view.messageField.text = "You've caught a fish!";
			}
			//-- createModel
			var model:ResourceSprite = _item.createModel();
			model.loadContent();
			GraphUtils.scale(model, view.stuffRect.height, view.stuffRect.width)
			view.addChild(model);
			
			var modelRect:Rectangle = model.getBounds(view);
			var positionRect:Rectangle = view.stuffRect.getBounds(view);
			model.x += (positionRect.x + 0.5 * positionRect.width)
				- (modelRect.x + 0.5 * modelRect.width)
			model.y += (positionRect.y + 0.5 * positionRect.height)
				- (modelRect.y + 0.5 * modelRect.height);
			view.removeChild(view.stuffRect);
			//--
			
			showDialog(view); 
		}
		
		private function get stuffs():Stuffs
		{
			 return Global.charManager.stuffs;
		}
		
	}
}