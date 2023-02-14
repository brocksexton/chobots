package com.kavalok.dialogs
{
	import flash.display.MovieClip;

	public class DialogView extends DialogOkView
	{
		public function DialogView(text:String, modal : Boolean = false)
		{
			super(text, false, null, modal);
		}
		
	}
}