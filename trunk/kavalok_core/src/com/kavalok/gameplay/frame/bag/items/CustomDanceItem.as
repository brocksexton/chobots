package com.kavalok.gameplay.frame.bag.items
{
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.gameplay.windows.McCustomDanceButton;
	
	import flash.events.MouseEvent;

	public class CustomDanceItem extends FlashViewBase
	{
		public function CustomDanceItem(content:McCustomDanceButton)
		{
			super(content);
			content.editButton.addEventListener(MouseEvent.CLICK, onEditClick);
		}
		
		private function onEditClick(event : MouseEvent) : void
		{
			
		}
		
	}
}