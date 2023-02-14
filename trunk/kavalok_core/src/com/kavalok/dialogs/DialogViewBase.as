package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.FlashView;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class DialogViewBase extends FlashView
	{
		public var textField : TextField;
		private var _modal:Boolean;
		
		public function DialogViewBase(content:Sprite, text : String, modal : Boolean = true)
		{
			_modal = modal;
			
			super(content);

			if(text != null)
			{
				if(textField != null && textField.htmlText != null) {
					textField.htmlText = text;
				}
			}
		}
		
		public function show(centerWindow : Boolean = true) : void
		{
			Dialogs.showDialogWindow(content, _modal, null, centerWindow);
		}
		
		public function hide() : void
		{
			GraphUtils.detachFromDisplay(content);
		}
		
	}
}