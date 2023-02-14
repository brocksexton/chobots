package org.goverla.utils {

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.graphics.IFill;
	
	public class GraphicsUtil {
		
		public static function fillRect(context : Graphics, fill : IFill, rectangle : Rectangle, cornerRadius : Number = 0) : void {
			fill.begin(context, rectangle);
			context.drawRoundRect(rectangle.left, rectangle.top, rectangle.width, rectangle.height, cornerRadius * 2);
			fill.end(context);
		}

	}

}