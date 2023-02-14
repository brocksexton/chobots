package com.kavalok.admin.infoPanel
{
	import com.kavalok.char.CharModels;
	import com.kavalok.dto.infoPanel.InfoPanelAdminTO;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.services.InfoPanelService;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.TypeRequirement;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import mx.controls.CheckBox;
	import mx.containers.Box;
	import mx.containers.ViewStack;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.core.Container;
	import mx.core.IRepeater;
	import org.goverla.collections.ArrayList;
	
	public class InfoItemBase extends Box
	{
		private var _infoItem:InfoPanelAdminTO;
		
		[Bindable] public var locales:ArrayList;
		[Bindable] public var localeTexts:Container;
		[Bindable] public var captionInput:TextInput;
		[Bindable] public var models:ArrayList = new ArrayList([
			CharModels.STAY,
			CharModels.WALK,
			CharModels.DANCE + '0',
			CharModels.DANCE + '1',
			CharModels.DANCE + '2',
			CharModels.DANCE + '3',
			CharModels.DANCE + '4',
			CharModels.DANCE + '5',
			CharModels.DANCE + '6',
			CharModels.DANCE + '7',
		]);
		
		[Bindable] public var urlInput:TextInput;
		[Bindable] public var namesInput:TextInput;
		[Bindable] public var modelsInput:TextInput;
		[Bindable] public var enabledCheckBox:CheckBox;
		
		[Bindable] public var saveButton:Button;
		[Bindable] public var customView:ViewStack;
		[Bindable] public var saved:Boolean;
		
		public function InfoItemBase()
		{
			
		}
		
		[Bindable]
		public function get infoItem():InfoPanelAdminTO
		{
			return _infoItem;
		}
		
		public function set infoItem(value:InfoPanelAdminTO):void
		{
			_infoItem = value;
			parseData(new XML(_infoItem.data));
			saved = (_infoItem.id > 0);
		}
		
		private function parseData(data:XML):void
		{
			var newLocales:ArrayList = new ArrayList();
			for each (var locale:String in KavalokConstants.LOCALES)
			{
				newLocales.addItem(new LocaleText(locale, data.text[locale]));
			}
			locales = newLocales;
			
			if ('charNames' in data)
				namesInput.text = data.charNames;
			if ('charModers' in data)
				modelsInput.text = data.charModels;
			if ('url' in data)
				urlInput.text = data.url;
		}
		
		protected function onSaveClick():void
		{
			var item:InfoPanelAdminTO = new InfoPanelAdminTO();
			item.id = _infoItem.id;
			item.caption = Strings.trim(captionInput.text);
			item.enabled = enabledCheckBox.selected;
			item.data = toXML();
			
			new InfoPanelService().saveEntity(item);
		}
		
		private function toXML():XML
		{
			var data:XML = <data/>;
			
			if (charNames.length > 0)
				data.charNames = charNames;
			
			if (charModels.length > 0)
				data.charModels = charModels;
			
			if (url.length > 0)
				data.url = url;
			
			data.text = getLocaleText();
			
			return data;
		}
		
		protected function onModelSelect(e:Event):void
		{
			var modelName:String = String(ComboBox(e.target).selectedItem);
			
			if (modelsInput.text.length > 0)
				modelsInput.text += ', ';
				
			modelsInput.text += modelName;
			ComboBox(e.target).selectedIndex = -1;
		}
		
		private function getLocaleText():XML
		{
			var result:XML = <text/>;
			var fields:Array = GraphUtils.getAllChildren(localeTexts,
				new TypeRequirement(TextInput));
			for each (var field:TextInput in fields)
			{
				result[field.name] = Strings.trim(field.text);
			}
			return result;
		}
		
		protected function onShowClick():void
		{
		}
		
		protected function onSendClick():void
		{
		}
		
		public function get charNames():String
		{
			return Strings.trim(namesInput.text);
		}
		
		public function get charModels():String
		{
			return Strings.trim(modelsInput.text);
		}
		
		public function get url():String
		{
			return Strings.trim(urlInput.text);
		}
	}
	
}
