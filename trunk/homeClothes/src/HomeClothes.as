package
{
	
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.wardrobe.Wardrobe;
	import com.kavalok.wardrobe.view.ItemSprite;
	import com.kavalok.wardrobe.view.MainView;
	
	import flash.display.Sprite;
	import com.kavalok.wardrobe.commands.QuitCommand;
	
	public class HomeClothes extends WindowModule
	{
		static private var _instance:HomeClothes;
		static public function get instance():HomeClothes
		{
			return _instance;
		}
		
		private var _wardrobe:Wardrobe;
		private var _mainView:MainView;
		
		public function HomeClothes()
		{
			Global.charManager.stuffs.removedItemFromWardrobe.addListenerIfHasNot(onItemRemovedEvent);
		}
		
		private function onItemRemovedEvent(le_item:StuffItemLightTO):void
		{
			if(_wardrobe != null && _mainView != null )
			{
				
				var children_items:Array = new Array();
				for (var i:int; i < _mainView.itemsContainer.numChildren; i++)
				{
					
					var child:ItemSprite = ItemSprite(_mainView.itemsContainer.getChildAt(i));
					trace("found a wardrobe item " + child.stuff.name);
					
					if(child.stuff.id == le_item.id)
					{
						child.deactivate();
						_mainView.itemsContainer.removeChildAt(i);
						_wardrobe.removeItemNoServer(child);
						trace("removed wardrobe item " + child.stuff.name);
					}
				}
				
			} else {
				trace("wardrobe and or mainview is null");
			}
		}
		
		override public function initialize():void
		{
			trace("initalizing wardrobe..");
			
			
			_instance = this;
			_wardrobe = new Wardrobe();
			_mainView = new MainView();
			addChild(_mainView.content);
			readyEvent.sendEvent();
			Global.currentBody = Global.charManager.body;
			Global.charManager.body = "brb";
		}
		
		/*
		private function onAddClothes(newItem:ItemSprite):void
		{
			stuffs.mergeClothes([newItem.stuff]);
			refresh();
		}
		
		private function onUndo():void
		{
			if (_usedItems.length > 0)
			{
				var item:StuffItemLightTO = _usedItems.pop();
				item.used = false;
				refresh();
			}
		}
*/		
		
		public function get wardrobe():Wardrobe { return _wardrobe; }
		public function get mainView():MainView { return _mainView; }
		
	}
	
}