package com.kavalok.admin.infoPanel
{
	
	public class LocaleText
	{
		[Bindable]
		public var locale:String;
		
		[Bindable]
		public var text:String;
		
		public function LocaleText(locale:String, text:String):void
		{
			this.locale = locale;
			this.text = text;
		}
	}
	
}