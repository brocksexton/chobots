package com.kavalok.location.modifiers
{
	import flash.display.MovieClip;
	
	public interface IClipModifier
	{
		function accept(clip : MovieClip):Boolean;
		function modify(clip : MovieClip):void;
	}
}