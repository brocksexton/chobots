package com.kavalok.admin.infoPanel
{
	import com.kavalok.gameplay.KavalokConstants;
	import mx.containers.VBox;
	import mx.events.FlexEvent;
	
	public class LocaleTextViewBase extends VBox
	{
		
		public function LocaleTextViewBase()
		{
			addEventListener(FlexEvent.INITIALIZE, onInitialize);
		}
		
		private function onInitialize(e:FlexEvent):void
		{
			for each (var locale in KavalokConstants.LOCALES)
			{
				addLocale(locale);
			}
		}
		
		private function addLocale(locale:String):void
		{
		}
		
	}
	
}