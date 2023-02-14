package com.kavalok.char
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	
	import flash.display.MovieClip;
	
	public class DefaultModelsFactory implements IModelsFactory, IIdleFactory
	{
		static private const IDLE_COUNT:int = 4;
		
		protected var _customModels:Object = {};
		
		public function DefaultModelsFactory()
		{
			addCustomModel('ModelIdle0');
			addCustomModel('ModelIdle1');
			addCustomModel('ModelIdle2');
			addCustomModel('ModelIdle3');
			
			addCustomModel('ModelDance0');
			addCustomModel('ModelDance1');
			addCustomModel('ModelDance2');
			addCustomModel('ModelDance3');
			addCustomModel('ModelDance4');
			addCustomModel('ModelDance5');
			addCustomModel('ModelDance6');
			addCustomModel('ModelDance7');
			addCustomModel('ModelDance8');
			addCustomModel('PlayMagic');
			addCustomModel('ModelCustomDance');
			
			for each (var playModel:String in CharModels.PLAY)
			{
				addCustomModel(playModel);
			}
			
			addCustomDirectionModel(CharModels.TAKE);
			addCustomDirectionModel(CharModels.THROW);
		}
		
		private function addCustomDirectionModel(classPrefix:String):void
		{
			var directions : Array = [Directions.DOWN, Directions.RIGHT_DOWN, Directions.RIGHT, Directions.RIGHT_UP, Directions.UP];
			for each(var direction : uint in directions)
			{
				addCustomModel(classPrefix + direction);
			}
			
		}
		private function addCustomModel(className:String):void
		{
			_customModels[className] = Global.classLibrary.getClass(
				URLHelper.charModels, className);
		}
		
		public function get randomIdleName():String
		{
			return CharModels.IDLE_PREFIX + int(Math.random() * IDLE_COUNT);
		}

		public function getModel(hasTool:Boolean, modelType:String, direction:int):MovieClip
		{
			var model:MovieClip;
			
			var d:int = direction;
			
			if (direction == Directions.LEFT_DOWN)
				d = Directions.RIGHT_DOWN;
			else if (direction == Directions.LEFT) 
				d = Directions.RIGHT;
			else if (direction == Directions.LEFT_UP)
				d = Directions.RIGHT_UP;
				
			var modelClass:Class;	
			
			if (modelType in _customModels)
			{
				modelClass = _customModels[modelType];
				model = MovieClip(new modelClass());
			}
			else if (modelType + d.toString() in _customModels)
			{
				modelClass = _customModels[modelType + d.toString()];
				model = MovieClip(new modelClass());
			}
			else
			{
				var className:String = (hasTool ? 'T' : '') + modelType + d.toString();
				modelClass = Global.classLibrary.getClass(URLHelper.charModels, className);
				model = MovieClip(new modelClass());
			}
			
			if (d != direction)
				model.scaleX = -1; 
			
			return model;
		}
		
	}
}