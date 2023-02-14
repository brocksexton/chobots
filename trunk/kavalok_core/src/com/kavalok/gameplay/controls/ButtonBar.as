package com.kavalok.gameplay.controls
{
	import com.kavalok.collections.ArrayList;
	import com.kavalok.events.EventSender;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ButtonBar
	{
		private var _buttonViews : ArrayList = new ArrayList();
		private var _selectedIndex : int = -1;
		private var _selectedIndexChangeEvent : EventSender = new EventSender();
		
		public function ButtonBar()
		{
		}
		
		public function get selectedIndexChangeEvent() : EventSender
		{
			return _selectedIndexChangeEvent;
		}
		public function get selectedIndex() : int
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value : int) : void
		{
			if(selectedIndex != value)
			{
				selectButton(_buttonViews[value].content);
				_selectedIndex = value;
			}
		}
		
		public function addButton(content : MovieClip) : void
		{
			var view : ToggleButton = new ToggleButton(content); 
			view.highliteOnOver = false;
			_buttonViews.addItem(view);
			content.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onButtonClick(event : MouseEvent) : void
		{
			var content : MovieClip = MovieClip(event.target);
			var newSelectedIndex : int = selectButton(content);
			if(selectedIndex != newSelectedIndex)
			{
				_selectedIndex = newSelectedIndex;
				selectedIndexChangeEvent.sendEvent();
			}
		}
		
		private function selectButton(content : MovieClip) : int
		{
			var newSelectedIndex : int = -1;
			for each(var view : ToggleButton in _buttonViews)
			{
				if(view.content == content)
				{
					view.toggle = true;
					newSelectedIndex = _buttonViews.indexOf(view);
				}
				else
				{
					view.toggle = false;
				}
			}	
			return newSelectedIndex;
		}

	}
}