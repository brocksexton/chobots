package com.kavalok.char.modifiers
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class FlameModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 30;
		
		private var bmp:BitmapData;
		private var a:Array = [];
		private var d:Array = [];
		private var r:Array = new Array(256);
		private var rand:Number = Math.random()*10000;
		private var effect:Bitmap;
		private var glow:GlowFilter = new GlowFilter(0xFFFF00, 1, 4, 4, 3, 1, false, false);
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			var w:Number = _char.model.width;
			var h:Number = _char.model.height;
			
			bmp = new BitmapData(w, h, true, 0);
			effect = new Bitmap(bmp);
			effect.blendMode = BlendMode.HARDLIGHT;
			effect.x = -0.5*effect.width;
			effect.y = -effect.height;
			_char.content.addChild(effect);
			
			for (var i:int = 0; i<10; i++)
			{
				a[i] = new Point(Math.random()*w, Math.random()*h);
				d[i] = new Point(Math.random()*10-5, Math.random()*10-5);
			}
			
			for (var j:int = 0; j<256; j++)
			{
				r[j] = 0;
			}
			
			r[128]=0x60FF3000;
			r[129]=0x80FF9000;
			r[130]=0xFFFFFF00;
			r[131]=0x80FF9000;
			r[132]=0x60FF3000;
			
			_char.content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			for (var i:int = 0; i<10; i++)
			{
				a[i].x += d[i].x;
				a[i].y += d[i].y;
			}
			
			bmp.perlinNoise(50, 50, 3, rand, false, true, 0, true, a);
			bmp.paletteMap(bmp, bmp.rect, new Point(0, 0), r, r, r, r);
			bmp.applyFilter(bmp, bmp.rect, new Point(0, 0), glow);
		}
		
		override protected function restore():void
		{
			GraphUtils.detachFromDisplay(effect);
			_char.content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

	}
}