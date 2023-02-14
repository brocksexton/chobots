package org.goverla.states
{
	import org.goverla.constants.StyleConstants;
	import org.goverla.constants.StyleNames;
	
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	import mx.states.IOverride;
	import mx.states.SetProperty;
	import mx.states.SetStyle;

	public class TextAreaToText implements IOverride
	{
		public var target : TextArea;
		
		private var _overrides : Array;
		
		public function TextAreaToText() : void {
			
		}
		
		public function remove(parent:UIComponent):void
		{
			for each(var overrider : IOverride in _overrides) {
				overrider.remove(parent);
			}
		}
		
		public function initialize():void
		{
			_overrides = [
				new SetProperty(target, "editable", false)
				, new SetStyle(target, StyleNames.BACKGROUND_ALPHA, 0)
				, new SetStyle(target, StyleNames.BORDER_STYLE, StyleConstants.BORDER_STYLE_NONE)];
		}
		
		public function apply(parent:UIComponent):void
		{
			for each(var overrider : IOverride in _overrides) {
				overrider.apply(parent);
			}
		}
		
	}
}