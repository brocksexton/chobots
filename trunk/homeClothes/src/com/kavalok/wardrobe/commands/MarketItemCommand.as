package com.kavalok.wardrobe.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.DialogMarketSellView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.wardrobe.ModuleController;
	import com.kavalok.services.AdminService;
	import com.kavalok.wardrobe.view.ItemSprite;
	
	import gs.TweenLite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class MarketItemCommand extends ModuleController
	{
		private var _item:ItemSprite;
		
		public function MarketItemCommand(item:ItemSprite)
		{
			_item = item;
		}
		
		public function execute():void
		{
			if (_item.stuff.shopName == 'shopItems')
			{
				Dialogs.showOkDialog("You cannot put items bought with Emeralds on the Market");
			} 
			else if(_item.stuff.shopName == 'agentsShop')
			{
				Dialogs.showOkDialog("You cannot put items from the Agents Shop on the Market");
			}
			else
			{
				new AdminService(marketVerified).verifyItemOwner(_item.stuff.id);
			}
		}

		public function marketVerified(val:Boolean):void
		{
			if(val) {
				var dialog:DialogMarketSellView = Dialogs.showMarketSellDialog(_item.stuff.id);
				dialog.done.addListener(closeM);
			} else {
				Dialogs.showOkDialog("Are you sure this item belongs to you? Maybe you already put it up for auction!");
				Global.isLocked = false;
			}
		}
		
		private function closeM():void
		{
			new QuitCommand().execute();
		}
		
		private function hideItem():void
		{
			_item.deactivate();
			TweenLite.to(_item, 1.0, {
				alpha: 0.0,
				onComplete:function():void {
					GraphUtils.detachFromDisplay(_item);
				}
			});
		}
		
	}
}