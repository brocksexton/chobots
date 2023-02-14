package com.kavalok.robotConfig
{
	import flash.display.Sprite;
	
	public class DropZone
	{
		public var content:Sprite;
		public var position:int;
		public var used:Boolean;
		
		public function DropZone(content:Sprite, position:int = 0)
		{
			this.content = content;
			this.position = position;
		}

	}
}