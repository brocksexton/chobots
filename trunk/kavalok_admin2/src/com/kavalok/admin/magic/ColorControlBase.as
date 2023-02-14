package com.kavalok.admin.magic
{
	import com.gskinner.geom.ColorMatrix;
	import com.kavalok.struct.ColorInfo;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import mx.containers.Canvas;
	import mx.controls.HSlider;
	import mx.controls.Image;

	/**
	 * ...
	 * @author Canab
	 */
	public class ColorControlBase extends Canvas
	{
		
		[Bindable] public var redSlider:HSlider;
		[Bindable] public var greenSlider:HSlider;
		[Bindable] public var blueSlider:HSlider;
		
		[Bindable] public var hueSlider:HSlider;
		[Bindable] public var saturationSlider:HSlider;
		[Bindable] public var brightnessSlider:HSlider;
		[Bindable] public var contrastSlider:HSlider;
		
		[Bindable] public var image:Image;
		[Bindable] public var imageSource:Object;
		
		public function ColorControlBase()
		{
			super();
		}
		
		public function refresh():void
		{
			image.transform.colorTransform = new ColorTransform(red, green, blue);
			
			var matrix:ColorMatrix = new ColorMatrix();
			matrix.adjustColor(brightness, contrast, saturation, hue);
			image.filters = [new ColorMatrixFilter(matrix)];
		}
		
		public function reset():void 
		{
			redSlider.value = 1;
			greenSlider.value = 1;
			blueSlider.value = 1;
			
			hueSlider.value = 0;
			saturationSlider.value = 0;
			brightnessSlider.value = 0;
			contrastSlider.value = 0;
			
			refresh();
		}
		
		public function get colorInfo():ColorInfo
		{
			var info:ColorInfo = new ColorInfo();
			info.red = red;
			info.green = green;
			info.blue = blue;
			info.hue = hue;
			info.saturation = saturation;
			info.brightness = brightness;
			info.contrast = contrast;
			
			return info;
		}
		
		public function get red():Number
		{
			return redSlider.value;
		}
		
		public function get green():Number
		{
			return greenSlider.value;
		}
		
		public function get blue():Number
		{
			return blueSlider.value;
		}
		
		public function get hue():Number
		{
			return hueSlider.value;
		}
		
		public function get saturation():Number
		{
			return saturationSlider.value;
		}
		
		public function get brightness():Number
		{
			return brightnessSlider.value;
		}
		
		public function get contrast():Number
		{
			return contrastSlider.value;
		}
	}
	
}