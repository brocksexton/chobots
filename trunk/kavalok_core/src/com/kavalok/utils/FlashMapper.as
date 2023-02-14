package com.kavalok.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class FlashMapper
	{
		private var _sprite:Sprite;
		
		public function FlashMapper(sprite:Sprite)
		{
			_sprite = sprite;
		}
		
		public function mapTo(object:Object):void
		{
			var children:Array = GraphUtils.getAllChildren(_sprite);
			
			for each (var child:DisplayObject in children)
			{
				if (child.name in object)
					object[child.name] = child;
			}
		}

	}
}