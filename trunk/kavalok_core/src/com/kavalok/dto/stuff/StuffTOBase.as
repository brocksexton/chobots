package com.kavalok.dto.stuff
{
	import com.kavalok.URLHelper;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.gameplay.ResourceSprite;
	
	import flash.utils.ByteArray;
	
	public class StuffTOBase
	{
		public static const MODEL_CLASS_NAME : String = "McStuff";
		
		public var id : int;

		public var fileName : String;
		
		public var type : String;

		public var name : String;

		public var price : int;
		
		public var emeralds : int;
		
		public var hasColor : Boolean;

		public var doubleColor:Boolean;

		public var premium : Boolean;
		
		
		

		public function StuffTOBase()
		{
		}

		public function get url():String
		{
			return URLHelper.stuffURL(fileName, type);
		}

		public function createModel():ResourceSprite
		{
			var result : ResourceSprite =  new ResourceSprite(url, MODEL_CLASS_NAME, false);
			if(hasColor && type != StuffTypes.ROBOT)
				result.makeGray();
			return result;
			
		}
	}
}