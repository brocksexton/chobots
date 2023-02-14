package com.kavalok.gameplay.controls
{
	import com.kavalok.events.EventSender;
	
	public class RadioGroup
	{
		private var _buttons:Array = [];
		private var _clickEvent:EventSender = new EventSender(RadioGroup);
		private var _selectedButton:CheckBox;
		
		public function RadioGroup()
		{
		}
		
		public function addButton(button:CheckBox):void
		{
			_buttons.push(button);
			button.clickEvent.addListener(onButtonClick);
		}
		
		private function onButtonClick(button:CheckBox):void
		{
			selectedButton = button;
			_clickEvent.sendEvent(this);
		}
		
		public function get selectedButton():CheckBox
		{
			 return _selectedButton;
		}
		
		public function set selectedButton(value:CheckBox):void
		{
			 if (_selectedButton)
			 	_selectedButton.checked = false;
			 	
			 _selectedButton = value;
			 
			 if (_selectedButton)
			 	_selectedButton.checked = true;
		}
		
		public function get selectedIndex():int
		{
			 return (_selectedButton)
			 	? _buttons.indexOf(_selectedButton)
			 	: -1;
		}
		
		public function set selectedIndex(value:int):void
		{
			 selectedButton = (value >=0)
			 	? _buttons[value]
			 	: null;
		}
		
		public function get buttons():Array
		{
			 return _buttons;
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }

	}
}