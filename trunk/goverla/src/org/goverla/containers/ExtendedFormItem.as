package org.goverla.containers {
	
	import mx.containers.FormItem;

	public class ExtendedFormItem extends FormItem {

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var labelObject : Object = rawChildren.getChildAt(1);			
			labelObject.x = 0;
		}
	}
}