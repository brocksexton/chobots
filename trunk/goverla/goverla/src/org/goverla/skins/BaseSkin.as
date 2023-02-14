package org.goverla.skins {
	
	import flash.display.MovieClip;
	
	import mx.core.IFlexDisplayObject;

	public class BaseSkin extends MovieClip implements IFlexDisplayObject {
		
		public function get measuredHeight() : Number {
			return height;
		}
		
		public function get measuredWidth() : Number {
			return width;
		}
		
		public function BaseSkin() {
			super();
		}
		
		public function setActualSize(newWidth : Number, newHeight : Number) : void {
			width = newWidth;
			height = newHeight;
		}
		
		public function move(x : Number, y : Number) : void {
			this.x = x;
			this.y = y;
		}
		
	}
	
}