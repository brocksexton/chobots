package com.kavalok.gameplay.chat
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public interface IBubbleSource
	{
		function get content():Sprite
		function get bubblePosition():Point
	}
}