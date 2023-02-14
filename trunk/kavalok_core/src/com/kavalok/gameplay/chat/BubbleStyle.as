package com.kavalok.gameplay.chat
{
	import flash.filters.GlowFilter;
	public class BubbleStyle
	{
		public var fontSize:int;
		public var frameNum:int;
		public var maxWidth:int;
		public var fontColor:String;
		public var Filter:GlowFilter;
		
		public function BubbleStyle(fontSize:int, frameNum:int, maxWidth:int, fontColor:String = null, filter:String = null)
		{
			this.fontSize = fontSize;
			this.frameNum = frameNum;
			this.maxWidth = maxWidth;
			this.fontColor = fontColor;
			
			switch (filter){
				case "red":
					this.Filter = new GlowFilter(0xFF0000, 50, 3, 3, 2, 50, false, false);
					break;
				case "green":
					this.Filter = new GlowFilter(0x00FF99, 50, 3, 3, 2, 50, false, false);
					break;
				case "black":
					this.Filter = new GlowFilter(0x000000, 50, 3, 3, 2, 50, false, false);
					break;
				case "white":
					this.Filter = new GlowFilter(0xFFFFFF, 50, 3, 3, 2, 50, false, false);
					break;
				case "white":
					this.Filter = new GlowFilter(0x0000A0, 50, 3, 3, 2, 50, false, false);
					break;
				default:
					return;
			}	
			
		}
	
	}
}