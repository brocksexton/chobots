package com.kavalok.wardrobe.view
{
	import assets.wardrobe.McWardrobe;
	
	import com.kavalok.Global;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.gameplay.controls.CheckBox;
	import com.kavalok.gameplay.controls.RadioGroup;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.wardrobe.ModuleController;
	import com.kavalok.wardrobe.commands.QuitCommand;
	import com.kavalok.wardrobe.commands.RemoveItemCommand;
	import com.kavalok.wardrobe.commands.MarketItemCommand;
	import com.kavalok.wardrobe.view.ItemSprite;
	import com.kavalok.services.AdminService;
	import com.kavalok.dialogs.DialogItemView;
		
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class MainView extends ModuleController
	{
		private var _content:McWardrobe;
		private var _charView:CharView;
		private var _recycleView:RecycleView;
		private var _marketView:MarketView;
		private var _colorView:ColorView;
		private var _groupSelector:RadioGroup;
		
		private var _itemsContainer:Sprite;
		private var _newPos:Sprite;
		private var _dragBounds:Rectangle;
		
		public function MainView():void
		{
			initContent();
			attachItems();
			
			_content.btnClose.addEventListener(MouseEvent.MOUSE_DOWN, onCloseClick);
			_groupSelector.clickEvent.addListener(onSelectorClick);
			
			ToolTips.registerObject(_content.btnClose, 'close', ResourceBundles.KAVALOK);
			
			GraphUtils.optimizeBackground(_content.background);
			Global.isWardrobe = true;			
		}
		
		public function get itemsContainer():Sprite
		{
			return _itemsContainer;
		}

		private function initContent():void
		{
			_content = new McWardrobe();
			_content.mcNewPos1.visible = false;
			_content.mcNewPos2.visible = false;
			_content.recycle.stop();
			_content.market.stop();
			_content.color.stop();
			ToolTips.registerObject(_content.market, "Send an item to the market", ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.color, "Change color of an item", ResourceBundles.KAVALOK);
			
			_dragBounds = new Rectangle(10, 10,
				KavalokConstants.SCREEN_WIDTH - 20,
				KavalokConstants.SCREEN_HEIGHT - 20);
			
			_newPos = _content.mcNewPos1;
			_charView = new CharView(_content);
			_recycleView = new RecycleView(_content.recycle);
			_marketView = new MarketView(_content.market);
			_colorView = new ColorView(_content.color);
			//_content.market.visible = false;
			
			_itemsContainer = new Sprite();
			_content.addChild(_itemsContainer);
			
			_groupSelector = new RadioGroup();
			_groupSelector.addButton(new CheckBox(_content.checkBox1));
			_groupSelector.addButton(new CheckBox(_content.checkBox2));
			_groupSelector.addButton(new CheckBox(_content.checkBox3));
			_groupSelector.addButton(new CheckBox(_content.checkBox4));
			_groupSelector.addButton(new CheckBox(_content.checkBox5));
			_groupSelector.selectedIndex = 0;
		}
		
		private function onSelectorClick(sender:Object):void
		{
			attachItems();
		}		
		
		private function attachItems():void
		{
			GraphUtils.removeChildren(_itemsContainer);
			Global.charManager.clothes = wardrobe.usedClothes;
			Global.charManager.stuffs.updateItems(wardrobe.updateList);
			Global.charManager.stuffs.refresh();
			var items:Array = wardrobe.getItems(_groupSelector.selectedIndex);
			for each (var item:ItemSprite in items)
			{
				if (!item.initialized)
					initItem(item);
				_itemsContainer.addChild(item);
			}
		}
		
		public function initItem(item:ItemSprite):void
		{
			item.initialize();
			//MousePointer.registerObject(item, MousePointer.HAND);
			item.startDragEvent.addListener(onStartDrag);
			item.finishDragEvent.addListener(onFinishDrag);
			item.dragEvent.addListener(onDrag);
			item.dragManager.bounds = _dragBounds;
			
			
			if (item.isNewStaff)
			{
				_newPos = (_newPos == _content.mcNewPos1)
					? _content.mcNewPos2
					: _content.mcNewPos1;
				
				item.position = GraphUtils.objToPoint(_newPos);
			}
		}
		
		private function onStartDrag(item:ItemSprite):void
		{
			item.selected = true;
			GraphUtils.bringToFront(item);
		}
		
		private function onDrag(item:ItemSprite):void
		{
			var recycled:Boolean = _recycleView.hitTestItem(item);
			if (recycled != item.recycled)
			{
				item.recycled = recycled;
				if (item.recycled)
					_recycleView.open();
				else
					_recycleView.close();
			}

			var marketed:Boolean = _marketView.hitTestItem(item);
			if (marketed != item.marketed)
			{
				item.marketed = marketed;
				if (item.marketed)
					_marketView.open();
				else
					_marketView.close();
				
			}
			
			var colored:Boolean = _colorView.hitTestItem(item);
			if (colored != item.colored)
			{
				item.colored = colored;
				if (item.colored)
					_colorView.open();
				else
					_colorView.close();
				
			}
		}
		
		private function onFinishDrag(item:ItemSprite):void
		{
			item.selected = false;
			
			if (_recycleView.hitTestItem(item))
			{
				new RemoveItemCommand(item).execute();
			}
			else if (_marketView.hitTestItem(item))
			{
				new MarketItemCommand(item).execute();
			}
			else if (_colorView.hitTestItem(item))
			{
				if(!item.stuff.hasColor) {
					Dialogs.showOkDialog("Oops, this item cant be recolored!");
					item.selected = false;
					item.dragManager.undoDrag();
					new QuitCommand().execute();
				} else {
					if(item.stuff.used) {
						Global.charManager.stuffs.unUseClothe(item.stuff);
					}
					var dialog:DialogItemView = Dialogs.showItemDialog(item.stuff);
					item.selected = false;
					item.dragManager.undoDrag();
					new QuitCommand().execute();
				}
			}
			else if (_charView.hitTestItem(item))
			{
				if (item.stuff.shopName == 'agentsShop')
				{
					if(!Global.charManager.isAgent) {
						Dialogs.showOkDialog("Oops, this item is exclusive to Agents only!");
						item.selected = false;
						item.dragManager.undoDrag();
						new QuitCommand().execute();
					}
				}
				
				if (item.stuff.shopName == 'shopItems')
				{
					if(!Global.charManager.isMerchant) {
						Dialogs.showOkDialog("Oops, this item is exclusive to Merchants only!");
						item.selected = false;
						item.dragManager.undoDrag();
						new QuitCommand().execute();
					}
				}

				if (item.enabled) {
					wardrobe.useItem(item);
				} else {
					if (Global.charManager.isGuest || Global.charManager.isNotActivated)
						new QuitCommand().execute();
					    new CitizenWarningCommand("wardrobe").execute();
				}
				item.dragManager.undoDrag();
			}
			else
			{
				item.updatePosition();
				wardrobe.addToUpdateList(item);
			}
		}
		
		public function closeRecycle():void
		{
			_recycleView.playToEnd();
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			new QuitCommand().execute();
			Global.isWardrobe = false;
		}
		
		public function get content():Sprite { return _content; }
		
	}
	
}