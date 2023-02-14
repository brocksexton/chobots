package com.kavalok.admin.magic
{
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.location.commands.StuffRainCommand;
	import com.kavalok.services.AdminService;
	import mx.controls.List;
	import org.goverla.collections.ArrayList;
	import mx.controls.CheckBox;
	import com.kavalok.admin.stuffs.StuffItemView;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import mx.controls.ColorPicker;
	import mx.controls.Alert;
	import flash.text.TextField;
	import flash.utils.*;
	import com.kavalok.services.LogService;
	import flash.ui.Keyboard;
	/**
	* ...
	* @author Canab
	*/

	public class RainBase extends MagicViewBase
	{

		[Bindable]
		public var stuffList:ArrayList = new ArrayList();
[Bindable] public var stuffItemView:StuffItemView;
		[Bindable]
		public var stuffCombo:List;
			[Bindable]
		public var color:Boolean = false;
		public var leColor:int = 0xFFFFFF;
		[Bindable] public var colorPicker : ColorPicker;
		[Bindable] public var lolCheckBox : CheckBox;

		public function RainBase()
		{
			super();
			StuffTypeTO.initialize();
			refreshList();
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		protected function refreshList():void 
		{
			new AdminService(onResult).getRainableStuffs();
		}

		private function onResult(result:Array):void
		{
			stuffList = new ArrayList(result);
		}

		public function onSendClick():void
		{
			var command:StuffRainCommand = new StuffRainCommand();
			command.itemId = stuffType.id;
			command.fileName = stuffType.fileName;
			command.stuffType = stuffType.type;
			command.itemColor = colorPicker.selectedColor;
			command.hasColor = lolCheckBox.selected;
			sendLocationCommand(command);
		//	Alert.show("color: " + colorPicker.selectedColor);
			new LogService().adminLog("Rained item " + stuffType.fileName + " at " + remoteId, 1, "magic");
		}
	protected function onColorChange():void
		{
			leColor = colorPicker.selectedColor;
			stuffItemView.setStuffType(stuffType, colorPicker.selectedColor);
		}
		public function get stuffType():StuffTypeTO
		{
			return StuffTypeTO(stuffCombo.selectedItem);
		}

		public function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER && stuffType.id)
			{
				var command:StuffRainCommand = new StuffRainCommand();
				command.itemId = stuffType.id;
				command.fileName = stuffType.fileName;
				command.stuffType = stuffType.type;
				sendLocationCommand(command);
			}
		}

	}

}