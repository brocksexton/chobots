package com.kavalok.gameplay.controls
{
	import com.kavalok.collections.ArrayList;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.MovieClip;
	
	public class ToggleButtonsGroup
	{
		private var _buttons : ArrayList = new ArrayList();
		private var _selectedButton : ToggleButton;
		
		public function ToggleButtonsGroup()
		{
		}
		
		public function add(button : ToggleButton) : void
		{
			_buttons.addItem(button);
		}
		
		public function get selectedButton() : ToggleButton
		{
			return _selectedButton;
		}
		public function get selectedMovie() : MovieClip
		{
			return selectedButton.content;
		}
		public function set selectedMovie(value : MovieClip) : void
		{
			if(_selectedButton != null)
			{
				_selectedButton.toggle = false;
			}
			
			_selectedButton = ToggleButton(Arrays.safeFirstByRequirement(_buttons
				, new PropertyCompareRequirement("content", value)));
			if(_selectedButton != null)
			{
				_selectedButton.toggle = true;
			}
		}

	}
}