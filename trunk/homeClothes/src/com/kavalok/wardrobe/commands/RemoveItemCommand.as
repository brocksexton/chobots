package com.kavalok.wardrobe.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.wardrobe.ModuleController;
	import com.kavalok.services.AdminService;
	import com.kavalok.wardrobe.view.ItemSprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import gs.TweenLite;

	public class RemoveItemCommand extends ModuleController
	{
		private var _item:ItemSprite;
		public var timer:Timer;
		public function RemoveItemCommand(item:ItemSprite)
		{
			timer = new Timer(4000,1);
			super();
			_item = item;
		}
		
		public function execute():void
		{
			if (_item.stuff.shopName == 'shopItems')
			{
				Dialogs.showOkDialog("You cannot sell items from bought with Emeralds");
			}
			else
			{
				var text:String = Strings.substitute(Global.messages.recycleWarning, _item.stuff.backPrice);
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
			//	dialog.yes.addListener(doRecycle);
				dialog.yes.addListener(delayedFunctionCall);
			}
		}
		
		public function doRecycle(e:TimerEvent) : void
		{
			new AdminService(trashVerified).verifyItemOwner(_item.stuff.id);
			timer.stop();
			Global.isLocked = false;
		}

		public function delayedFunctionCall() : void
		{
			Global.isLocked = true;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,doRecycle);
			timer.start();
		}

		public function trashVerified(val:Boolean):void
		{
			if(val){
				hideItem();
				wardrobe.removeItem(_item);
				module.mainView.closeRecycle();
			
				new AddMoneyCommand(_item.stuff.backPrice, "recycle " + _item.stuff.fileName, false, null, false).execute();
			}
			else
			{
				Dialogs.showOkDialog("Are you sure this item belongs to you? Maybe you put it up for auction!");
				Global.isLocked = false;
				module.mainView.closeRecycle();
			}
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