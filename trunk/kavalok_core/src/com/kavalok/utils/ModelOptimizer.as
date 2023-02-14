package com.kavalok.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class ModelOptimizer
	{
		private var _clip:MovieClip;
		private var _frameCounter:int = 0;
		
		public function ModelOptimizer(clip:MovieClip)
		{
			_clip = clip;
			_clip.addEventListener(Event.ENTER_FRAME, onClipFrame);
			trace(_clip)
		}
		
		private function onClipFrame(e:Event):void
		{
			var bounds:Rectangle = _clip.getBounds(_clip);
			var transform:Matrix = new Matrix();
			
			transform.translate(-bounds.x, -bounds.y);
			
			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0);
			bitmapData.draw(_clip, transform);
			
			/*while (_clip.numChildren > 0)
			{
				_clip.removeChildAt(0);
			}*/
			
			trace(_frameCounter)
			
			var bitmap:Bitmap = new Bitmap(bitmapData);
			_clip.addChild(bitmap);
			
			if (++_frameCounter == _clip.totalFrames)
			{
				_clip.removeEventListener(Event.ENTER_FRAME, onClipFrame);
			}
		}

	}
}