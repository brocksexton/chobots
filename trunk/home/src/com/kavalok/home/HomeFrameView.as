package com.kavalok.home
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.gameplay.frame.bag.StuffList;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.home.data.HomeFrameStates;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	import com.kavalok.utils.converting.ConstructorConverter;
	
	import flash.events.MouseEvent;
	
	public class HomeFrameView extends FlashViewBase
	{
		private static const ROW_COUNT : int = 2;
		private static const COLUMN_COUNT : int = 3;
		private static const FRAMES : int = 10;
		private static const BOX_MIDDLE_POSITION : int = -142;
		private static const BOX_UP_POSITION : int = -214;
		
		
		private static var bundle : ResourceBundle = Localiztion.getBundle(Modules.HOME);
		
		private var _stuffSelectEvent : EventSender = new EventSender();
		private var _editModeEvent : EventSender = new EventSender();
		
		private var _content : McHomeFrame;
		private var _furniture : Array;
		private var _stuffList : StuffList;
		private var _openButton : StateButton;
		private var _state : String;
		
		public function HomeFrameView()
		{
			_content = new McHomeFrame();
			super(_content);
			_stuffList = new StuffList(_content.furnitureBox.furnitureList, ROW_COUNT, COLUMN_COUNT);
			_stuffList.selectedItemChange.addListener(onStuffSelect);
//			if(!Global.charManager.isCitizen)
//			{
//				ToolTips.registerObject(_stuffList.content, "onlyForCitizens", Modules.HOME);				
//			}
			_content.furnitureBox.downButton.addEventListener(MouseEvent.CLICK, onOpenClick);
			_content.furnitureBox.upButton.addEventListener(MouseEvent.CLICK, onUpClick);

			_content.furnitureBox.backButton.addEventListener(MouseEvent.CLICK, onBackClick);
			_content.furnitureBox.nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
			
			_openButton = new StateButton(_content.openButton, false);
			_content.openButton.addEventListener(MouseEvent.CLICK, onOpenClick);
			
		}
		
		public function get stuffSelectEvent() : EventSender
		{
			return _stuffSelectEvent;
		}

		public function get editModeEvent() : EventSender
		{
			return _editModeEvent;
		}
		
		public function get overBox() : Boolean
		{
			return _content.furnitureBox.hitTestPoint(Global.stage.mouseX, Global.stage.mouseY, true);
		}
		public function set furniture(value : Array) : void
		{
			_furniture = value;
			var items : Array = Arrays.getByRequirement(value, new PropertyCompareRequirement("used", false));
			items = Arrays.getConverted(items, new ConstructorConverter(StuffSprite));
			_stuffList.setItems(items);
			refreshOpenButton();
			refreshBackNext();
		}
		
		public function addFurniture(item : StuffItemLightTO) : void
		{
			var sprite:StuffSprite = new StuffSprite(item);
			_stuffList.addItem(sprite);
			refreshOpenButton();
			refreshBackNext();
		}
		
		private function onBackClick(event : MouseEvent) : void
		{
			_stuffList.pageIndex--;
			refreshBackNext();
		}
		private function onNextClick(event : MouseEvent) : void
		{
			_stuffList.pageIndex++;
			refreshBackNext();
		}
		private function refreshBackNext() : void
		{
			GraphUtils.setBtnEnabled(_content.furnitureBox.backButton, _stuffList.backEnabled);
			GraphUtils.setBtnEnabled(_content.furnitureBox.nextButton, _stuffList.nextEnabled);
		}
		private function onUpClick(event : MouseEvent) : void
		{
			if(_state == HomeFrameStates.OPEN)
			{
				_state = HomeFrameStates.MIDDLE;
				moveBox(BOX_MIDDLE_POSITION);				
			} 
			else
			{
				_state = HomeFrameStates.MIDDLE;
				moveBox(BOX_UP_POSITION);
				_content.openButton.visible = true;
				editModeEvent.sendEvent(false);
			}
			
			
		}
		private function refreshOpenButton() : void
		{
			_openButton.state = _stuffList.items.length > 0 ? 2 : 1;
		}
		private function moveBox(y : Number) : void
		{
			new SpriteTweaner(_content.furnitureBox, {y : y}, FRAMES);
			
		}
		private function onOpenClick(event : MouseEvent) : void
		{
			editModeEvent.sendEvent(true);
			_state = HomeFrameStates.OPEN;
			_content.openButton.visible = false;
			moveBox(0);
		}
		
		private function onStuffSelect() : void
		{
//			if(!Global.charManager.isCitizen)
//				return;
			if(_stuffList.selectedItem == null)
				return;
			stuffSelectEvent.sendEvent(_stuffList.selectedItem.item);
			_stuffList.removeItem(_stuffList.selectedItem);
			refreshOpenButton();
			refreshBackNext();
		}

	}
}