package com.kavalok.pinball.spaceBuilders
{
	public interface IDynamicSpaceBuilder extends ISpaceBuilder
	{
		function step() : void;
		function stop() : void;
	}
}