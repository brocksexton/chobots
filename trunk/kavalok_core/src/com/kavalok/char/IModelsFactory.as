package com.kavalok.char
{
	import flash.display.MovieClip;
	
	public interface IModelsFactory
	{
		function getModel(hasTool : Boolean, modelType : String, direction : int) : MovieClip;
	}
}