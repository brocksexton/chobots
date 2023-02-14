package com.kavalok.location
{
	import com.kavalok.char.DefaultModelsFactory;

	public class ModelsFactory extends DefaultModelsFactory
	{
		public static const MODEL_DRAG : String = "ModelDrag";
		public static const MODEL_FALL : String = "ModelFall";
		
		public function ModelsFactory()
		{
			super();
			_customModels[MODEL_DRAG] = ModelDrag;
			_customModels[MODEL_FALL] = ModelFall;
		}
		
	}
}