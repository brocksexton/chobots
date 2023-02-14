package com.kavalok.location.randomClips
{
	import com.kavalok.constants.BrowserConstants;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.comparing.ClassRequirement;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	public class LinkClip
	{
		public static const PREFIX : String = "link";
		
		private var _url : String;
		public function LinkClip(movie : MovieClip)
		{
			var fields : Array = GraphUtils.getAllChildren(movie, new ClassRequirement(TextField));
			var field : TextField = fields[0];
			movie.useHandCursor = true;
			movie.mouseChildren = false;
			movie.buttonMode = true;
			field.visible = false;
			movie.addEventListener(MouseEvent.CLICK, onClick);
			_url = field.text;
		}
		
		private function onClick(event : MouseEvent) : void
		{
			navigateToURL(new URLRequest(_url), BrowserConstants.BLANK);
		}

	}
}