package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.Global;
	import com.kavalok.char.modifiers.DanceModifier;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.frame.bag.dance.CustomDanceItem;
	import com.kavalok.gameplay.frame.bag.dance.DanceItem;
	import com.kavalok.gameplay.windows.McCustomDanceButton;
	import com.kavalok.gameplay.windows.McDance;
	import com.kavalok.gameplay.windows.McDanceButton;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.modules.ModuleEvents;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.Timers;
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	public class MiniDanceView
	{
		static private const MAX_ITEMS:int = 5;

		private var lastUsedTime:int = 0;
		
		private var _content:McDance = new McDance();
		private var _items:ArrayList = new ArrayList();
		private var _selection:ArrayList = new ArrayList();
		
		private var _applyEvent:EventSender = new EventSender();
		private var _openEvent:EventSender = new EventSender();
		private var _clickedItem:CustomDanceItem;
		
		public function MiniDanceView()
		{
			new ResourceScanner().apply(_content);
			_content.danceButton.addEventListener(MouseEvent.CLICK, onDanceClick);
			createItems();
		}
		
		private function createItems():void
		{
			var buttons:ArrayList = new ArrayList(GraphUtils.getAllChildren(_content, new TypeRequirement(McDanceButton)));
			
			for each (var clip:McDanceButton in buttons)
			{
				var item:DanceItem = new DanceItem(clip);
				item.clickEvent.addListener(onItemClick);
				_items.addItem(item);
			}
			var customDances:Array = GraphUtils.getAllChildren(_content, new TypeRequirement(McCustomDanceButton));
			for each (var customClip:McCustomDanceButton in customDances)
			{
				var customItem:CustomDanceItem = new CustomDanceItem(customClip);
				customItem.clickEvent.addListener(onCustomItemClick);
				customItem.editEvent.addListener(onCustomDanceEdit);
				_items.addItem(customItem);
			}
		}
		
		private function onCustomDanceEdit(item:CustomDanceItem):void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
				return;
			}
			_clickedItem = null;
			var events:ModuleEvents = editDance(item.customDanceIndex);
			events.destroyEvent.addListener(onDanceConstructorDestroy);
		}
		
		private function editDance(index:int):ModuleEvents
		{
			return Global.moduleManager.loadModule(Modules.DANCE_CONSTRUCTOR, {index: index});
		}
		
		private function onDanceConstructorDestroy(module:ModuleBase):void
		{
			if (_clickedItem && _clickedItem.hasDance)
				onItemClick(_clickedItem);
			Timers.callAfter(openEvent.sendEvent, 1);
		}
		
//		private function playCustomDance():void
//		{
//			if(Global.locationManager.location == null)
//				return;
//			var dance : Array = Global.charManager.dances[_customDanceIndex];
//			if(dance)
//				Global.locationManager.location.sendCustomDance(dance);
//		}
		private function onCustomItemClick(item:CustomDanceItem):void
		{
			/*if (Global.charManager.charLevel < 15)
			{
				Dialogs.showOkDialog("You have to be level 15 to use custom dances!")
			}
			else*/
			{
				if (Global.charManager.isGuest || Global.charManager.isNotActivated)
				{
					new RegisterGuestCommand().execute();
					return;
				}
				if (!item.hasDance || !Global.charManager.isCitizen)
				{
					var events:ModuleEvents = editDance(item.customDanceIndex);
					events.destroyEvent.addListener(onDanceConstructorDestroy);
					_clickedItem = item;
					return;
				}
				onItemClick(item);
			}
		}
		
		private function onItemClick(item:DanceItem):void
		{
			
			//if (item.value == "ModelDance8" && Global.charManager.charLevel != 8){
			//		Dialogs.showOkDialog("You have to be level 8...", true);
			//	} else {
			
			if (item.order == 0)
			{
				if (_selection.length < MAX_ITEMS)
					addToSelection(item);
			}
			else
			{
				removeFromSelection(item);
			}
		
			//	}
		}
		
		private function addToSelection(item:DanceItem):void
		{
			_selection.addItem(item);
			item.order = _selection.length;
		}
		
		private function removeFromSelection(item:DanceItem):void
		{
			item.order = 0;
			_selection.removeItem(item);
			reorderSelection();
		}
		
		private function reorderSelection():void
		{
			for (var i:int = 0; i < _selection.length; i++)
			{
				DanceItem(_selection[i]).order = i + 1;
			}
		}
		
		private function onDanceClick(e:MouseEvent):void
		{
			if (!Global.locationManager.danceEnabled)
				return;

			if(lastUsedTime + 5 > (getTimer() * 0.001)){
				return;
			}

			lastUsedTime = getTimer() * 0.001;
		
			var modifierName:String = getQualifiedClassName(DanceModifier);
			
			if (_selection.length > 0)
			{
				var dances:Array = [];
				
				for each (var item:DanceItem in _selection)
				{
					dances.push(item.value);
				}
				
				Global.charManager.addModifier(modifierName, dances);
				Global.addCheck(1,"dance");
			}
			else
			{
				Global.charManager.removeModifier(modifierName);
			}
			
			_applyEvent.sendEvent();
		}
		
		public function get openEvent():EventSender
		{
			return _openEvent;
		}
		
		public function get applyEvent():EventSender
		{
			return _applyEvent;
		}
		
		public function get content():MovieClip
		{
			return _content;
		}
	
	}
}

