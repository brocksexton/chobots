package com.kavalok.gameplay.controls.effects
{
	import com.kavalok.events.EventSender;
	
	import flash.display.DisplayObject;
	
	public interface IEffect
	{
		function get finishEvent() : EventSender;
		function play(object : DisplayObject) : void;
	}
}