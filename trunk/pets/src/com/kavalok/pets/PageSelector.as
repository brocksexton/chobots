package com.kavalok.pets
{
	import com.kavalok.events.EventSender;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PageSelector
	{
		private var _selectedItem:Sprite;
		private var _pageChange:EventSender = new EventSender();
		
		public function PageSelector(content:McPetsConstructor)
		{
			initButton(content.bodyButton);
			initButton(content.faceButton);
			initButton(content.topButton);
			initButton(content.sideButton);
			initButton(content.bottomButton);
			
			setSelectedItem(content.bodyButton);
		}
		
		private function initButton(button:Sprite):void
		{
			setButtonState(button, false);
			button.buttonMode = true;
			button.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onButtonClick(e:MouseEvent):void
		{
			var button:Sprite = e.currentTarget as Sprite;
			setSelectedItem(button);
			
			_pageChange.sendEvent();
		}
		
		public function get placement():String
		{
			return _selectedItem.name.replace('Button', '');
		}
		
		private function setSelectedItem(button:Sprite):void
		{
			if (_selectedItem)
				setButtonState(_selectedItem, false);
				
			_selectedItem = button;
			
			if (_selectedItem)
				setButtonState(_selectedItem, true);
		}
		
		private function setButtonState(button:Sprite, selected:Boolean):void
		{
			var frameNum:int = selected ? 2 : 1;
			var background:MovieClip = MovieClip(button);
			
			background.gotoAndStop(frameNum);
		}
		
		public function get pageChange():EventSender { return _pageChange; }
		public function get selectedItem():Sprite { return _selectedItem; }
	}
	
}