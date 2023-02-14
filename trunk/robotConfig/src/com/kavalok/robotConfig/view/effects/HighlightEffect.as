package com.kavalok.robotConfig.view.effects
{
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import com.kavalok.utils.GraphUtils;
	
	public class HighlightEffect
	{
		private var _target:DisplayObject;
		private var _filters:Array = 
		[
			new GlowFilter(0xFFFF00, 1, 4, 4, 5),
			new DropShadowFilter(0, 45, 0, 1),
		]
		
		
		public function HighlightEffect(target:DisplayObject)
		{
			_target = target;
		}
		
		public function apply():void
		{
			GraphUtils.addFilters(_target, _filters);
		}
		
		public function restore():void
		{
			GraphUtils.removeFilters(_target, _filters);
		}

	}
}