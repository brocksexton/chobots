package com.kavalok.pinball.spaceBuilders
{
	public interface IDynamicProcessor
	{
		function tryStart() : Boolean;
		function stop() : void;
	}
}