package com.kavalok.membership
{
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.comparing.ClassRequirement;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class BoldFormatter
	{
		public function BoldFormatter()
		{
		}
		
		public function apply(content : DisplayObjectContainer) : void
		{
			var fields : Array = GraphUtils.getAllChildren(content, new ClassRequirement(TextField));
			for each(var field : TextField in fields)
			{
				var format : TextFormat = field.getTextFormat();
				format.bold = true;
				field.setTextFormat(format);
			}
		}

	}
}