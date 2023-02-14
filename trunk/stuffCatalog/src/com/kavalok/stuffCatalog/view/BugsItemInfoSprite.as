package com.kavalok.stuffCatalog.view
{
	import com.kavalok.Global;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Strings;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class BugsItemInfoSprite extends Sprite
	{
		private var _item:StuffTypeTO;
		private var _robotsBundle:ResourceBundle;
		private var _itemsBundle:ResourceBundle;
		private var _field:TextField;
		
		public function BugsItemInfoSprite(item:StuffTypeTO)
		{
			_item = item;
			createContent();
		}
		
		private function createContent():void
		{
			var itemName:String = Global.resourceBundles.kavalok.messages.bugs;
			
			var text:String = '<center>   '+_item.skuInfo.bugs + ' ' +_item.skuInfo.emeralds + ' ' + itemName+'</center>';
			
			var format:TextFormat = new TextFormat();
			format.font = 'tahoma';
			format.color = 0x663300;
			format.size = 30;
			format.bold = false;
			format.align = TextFormatAlign.LEFT;
			
			_field = new TextField();
			_field.defaultTextFormat = format;
			_field.wordWrap = false;
			_field.multiline = true;
			_field.selectable = false;
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.htmlText = text;
			_field.height = _field.textHeight + 10;
			
			addChild(_field);
		}
		
		public function get htmlText():String
		{
			 return _field.htmlText;
		}
		
	}
}