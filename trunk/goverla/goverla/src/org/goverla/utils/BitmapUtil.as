package org.goverla.utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.utils.ColorUtil;
	
	public class BitmapUtil {

		public static function captureBitmapData(source : UIComponent,
			captureWidth : Number,
			captureHeight : Number,
			maintainAspectRatio : Boolean = true,
			colorTransform : ColorTransform = null,
			blendMode : String = null,
			clipRect : Rectangle = null,
			smoothing : Boolean = false) : BitmapData {

			if (maintainAspectRatio) {
				if (captureHeight / source.height > captureWidth / source.width) {
					captureHeight = source.height * (captureWidth / source.width);
				} else {
					captureWidth = source.width * (captureHeight / source.height);
				}
			}
			var result : BitmapData = new BitmapData(captureWidth, captureHeight);
			var matrix : Matrix = new Matrix();
			matrix.scale(captureWidth / source.width, captureHeight / source.height);
			result.draw(source, matrix, colorTransform, blendMode, clipRect, smoothing);

			return result;
		}
		
		public static function captureComponent(source : UIComponent,
			captureWidth : Number,
			captureHeight : Number) : UIComponent {

			var captureBitmapData : BitmapData = captureBitmapData(source, captureWidth, captureHeight);
			var captureBitmap : Bitmap = new Bitmap(captureBitmapData);

			var result : UIComponent = new UIComponent();
			result.width = captureBitmap.width;
			result.height = captureBitmap.height;
			result.addChild(captureBitmap);

			return result;
		}
		
		public static function adjustBrightness(bitmapData : BitmapData, brite : Number) : void {
			for (var i : uint = 0; i < bitmapData.width; i++) {
				for (var j : uint = 0; j < bitmapData.height; j++) {
					var color : uint = bitmapData.getPixel(i, j);
					if (color != 0xFFFFFF) {
						bitmapData.setPixel(i, j, ColorUtil.adjustBrightness(color, brite));
					}
				}
			}
		}
		
		public static function adjustBrightness2(bitmapData : BitmapData, brite : Number) : void {
			for (var i : uint = 0; i < bitmapData.width; i++) {
				for (var j : uint = 0; j < bitmapData.height; j++) {
					var color : uint = bitmapData.getPixel(i, j);
					if (color != 0xFFFFFF) {
						bitmapData.setPixel(i, j, ColorUtil.adjustBrightness2(color, brite));
					}
				}
			}
		}
	}
}