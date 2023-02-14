package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.pinball.space.EventSpace;
	
	import flash.display.DisplayObject;
	
	public interface ISpaceBuilder
	{
		function process(displayObject : DisplayObject, space : EventSpace, game : GamePinball) : void;
	}
}