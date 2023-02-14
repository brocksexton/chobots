package com.kavalok.utils
{
	import flash.display.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.kavalok.collections.ArrayList;
	import com.kavalok.utils.ReflectUtil;
	
	public class Debug 
	{
		static public function drawPoint(d:Sprite, point:Point, color:int = 0xFF0000, text:Object = null):void
		{
			d.graphics.lineStyle(0, color);
			d.graphics.drawCircle(point.x, point.y, 3);
			
			if (text != null)
			{
				var t:TextField = new TextField();
				var tf:TextFormat = new TextFormat(null, 9);
				
				t.text = text.toString();
				t.x = point.x;
				t.y = point.y;
				t.selectable = false;
				t.setTextFormat(tf);
				d.addChild(t);
			}
		}
		
		static public function traceObject(object:Object):void
		{
			var props:ArrayList = ReflectUtil.getFieldsAndPropertiesByInstance(object);
			
			for each (var prop:String in props)
			{
				trace(prop, ':', object[prop]);
			}
		}
	
	}
}