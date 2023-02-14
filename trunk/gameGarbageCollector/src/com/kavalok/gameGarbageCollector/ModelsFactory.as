package com.kavalok.gameGarbageCollector
{
	import com.kavalok.char.CharModels;
	import com.kavalok.char.IModelsFactory;
	import com.kavalok.garbageCollector.Char;
	import com.kavalok.garbageCollector.CharMove;
	
	import flash.display.MovieClip;

	public class ModelsFactory implements IModelsFactory
	{
		private static var _directions : Array = [90, 135, 180, 225, 270, 315, 0, 45];
		
		public function ModelsFactory()
		{
		}

		public function getModel(hasTool:Boolean, modelType:String, direction:int):MovieClip
		{
			var model : MovieClip = modelType == CharModels.STAY ? new Char() : new CharMove();
			model.rotation = _directions[direction];
			return model;
		}
		
		public function get tools():Object { return {}; };
		
	}
}