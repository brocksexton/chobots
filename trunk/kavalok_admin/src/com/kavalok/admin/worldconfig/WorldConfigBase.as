package com.kavalok.admin.worldconfig
{
	import com.kavalok.admin.worldconfig.data.WorldConfigData;
	import com.kavalok.services.AdminService;
	//import com.kavalok.remoting.commands.ApplyModCommand;
	import com.kavalok.char.CharModels;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	import mx.controls.ComboBox;
	import com.kavalok.Global;
	import org.goverla.collections.ArrayList;
	import flash.events.Event;
	import com.kavalok.utils.Strings;
	import mx.controls.Alert;
	
	public class WorldConfigBase extends VBox
	{
		public var safeModeEnabledCheckBox : CheckBox;
		public var drawingWallDisabledCheckBox : CheckBox;
		
		[Bindable] public var dataProvider : WorldConfigData = new WorldConfigData();
		[Bindable] public var usernameInput : TextInput;
		[Bindable] public var modifiersComboBox:ComboBox;
		[Bindable] public var modInput : String;
		[Bindable] public var modifiers:ArrayList = new ArrayList(CharModels.MODIFIERS);
	    [Bindable] protected var changed : Boolean;
		[Bindable] public var blahdubla:Boolean = false;
		[Bindable] public var globalCheckBox: CheckBox;
		
		public function WorldConfigBase()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		}
		
		protected function onSaveClick(event : MouseEvent) : void
		{
			dataProvider.safeModeEnabled = safeModeEnabledCheckBox.selected;
			dataProvider.drawingWallDisabled = drawingWallDisabledCheckBox.selected;
			dataProvider.update();
			changed = false;
		}
		protected function onMaintenanceClick(event: MouseEvent) : void
		{
			new AdminService().serverMaintenance(false);
			new AdminService().setServerAvailable(1, false);
			new AdminService().setServerAvailable(2, false);
			new AdminService().setServerAvailable(3, false);
			new AdminService().setServerAvailable(4, false);
			new AdminService().setServerAvailable(5, false);
			new AdminService().setServerAvailable(6, true);
			new AdminService().setServerAvailable(7, false);
			new AdminService().setServerAvailable(8, false);
			
		}
		protected function onMaintenanceDisClick(event: MouseEvent) : void
		{
			new AdminService().serverMaintenance(true);
			new AdminService().setServerAvailable(1, true);
			new AdminService().setServerAvailable(2, true);
			new AdminService().setServerAvailable(3, true);
			new AdminService().setServerAvailable(6, false);

			
		}
		
			private function onMouseDown(e:MouseEvent):void
			{
				if (e.shiftKey)
				     {
				      blahdubla = true;
				}
			}
		protected function makeSuperUser(e:MouseEvent):void
		{
			var userId:int = parseInt(usernameInput.text);
			new AdminService().superUser(usernameInput.text);
		}
		
		
		protected function applyMod(e:MouseEvent):void
		{
		    var userId:int = parseInt(usernameInput.text);
		    if(globalCheckBox.selected == true)
			{
			  new AdminService().applyMod(userId, charModifier);
			  Alert.show('Global Function is not yet Available');
			}else{
			new AdminService().applyMod(userId, charModifier);
			}
			
		}
		
		public function get charModifier():String
		{
			return String(modifiersComboBox.selectedItem);
		}
		
	}
}