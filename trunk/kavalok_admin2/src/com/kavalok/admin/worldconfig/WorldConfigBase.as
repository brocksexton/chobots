package com.kavalok.admin.worldconfig
{
	import com.kavalok.admin.worldconfig.data.WorldConfigData;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.CheckBox;

	public class WorldConfigBase extends VBox
	{
		public var safeModeEnabledCheckBox : CheckBox;
		
		[Bindable]
		public var dataProvider : WorldConfigData = new WorldConfigData();
		
		[Bindable]
		protected var changed : Boolean;
		
		public function WorldConfigBase()
		{
			super();
		}
		
		protected function onSaveClick(event : MouseEvent) : void
		{
			dataProvider.safeModeEnabled = safeModeEnabledCheckBox.selected;
			dataProvider.update();
			changed = false;
		}
		
	}
}