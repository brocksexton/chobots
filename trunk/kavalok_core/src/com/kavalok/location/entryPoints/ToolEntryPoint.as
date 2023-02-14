package com.kavalok.location.entryPoints
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class ToolEntryPoint extends SpriteEntryPoint
	{
		private var _toolName:String;
		
		public function ToolEntryPoint(content:Sprite, toolName:String, position:Point=null)
		{
			_toolName = toolName;
			
			super(content, position);
		}
		
		override public function goIn():void
		{
			_location.sendUserTool(_toolName);
			super.goIn();
		}

	}
}