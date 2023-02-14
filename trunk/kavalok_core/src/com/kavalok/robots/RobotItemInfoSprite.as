package com.kavalok.robots
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Strings;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class RobotItemInfoSprite extends Sprite
	{
		private var _item:RobotItemTO;
		private var _robotsBundle:ResourceBundle;
		private var _itemsBundle:ResourceBundle;
		private var _field:TextField;
		
		public function RobotItemInfoSprite(item:RobotItemTO)
		{
			_item = item;
			_robotsBundle = Global.resourceBundles.robots;
			_itemsBundle = Global.resourceBundles.robotItems;
			
			createContent();
		}
		
		private function createContent():void
		{
			var itemName:String = _itemsBundle.messages[_item.name] || _item.name;
			
			var text:String = '<b>' + itemName + '</b>';
			text += '<br/>';
			if (!_item.isBody)
				text += addLevel();
			text += addParameter('energy');
			text += addParameter('attack');
			text += addParameter('defence');
			text += addParameter('mobility');
			text += addParameter('accuracy');
			
			if (_item.remains >= 0)
				text += addRemains();
			else if (_item.useCount >= 0)
				text += addUseCount();
			
			if (_item.lifeTime > 0)
				text += addLifeTime();
			
			if (_item.expirationDate)
				text += addExpDate();
			
			var format:TextFormat = new TextFormat();
			format.font = 'tahoma';
			format.color = 0x663300;
			format.size = 14;
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
		
		private function addExpDate():String
		{
			var format:String = '<font size="12" color="#008000"><b>{0}: {1}</b></font><br/>'
			
			var result:String = Strings.substitute(format,
				_robotsBundle.messages.daysLeft, String(_item.daysLeft));
			
			return result;
		}
		
		private function addLevel():String
		{
			var format:String = '<font size="12" color="#808080">{0}: <b>{1}</b></font><br/>'
			var result:String = Strings.substitute(format,
				_robotsBundle.messages.level, String(_item.level));
			
			return result;
		}
		
		private function addRemains():String
		{
			var format:String = '<font size="12" color="#AA0000"><b>{0}: {1}/{2}</b></font><br/>'
			var result:String = Strings.substitute(format,
				_robotsBundle.messages.remains, String(_item.remains), String(_item.useCount));
			
			return result;
		}
		
		private function addUseCount():String
		{
			var format:String = '<font size="12" color="#AA0000"><b>{0}: {1}</b></font><br/>'
			var result:String = Strings.substitute(format,
				_robotsBundle.messages.useCount, String(_item.useCount));
			
			return result;
		}
		
		private function addLifeTime():String
		{
			var format:String = '<font size="12" color="#AA0000"><b>{0}: {1}</b></font><br/>'
			var result:String = Strings.substitute(format,
				_robotsBundle.messages.lifeTime, String(_item.lifeTime));
			
			return result;
		}
		
		private function addParameter(parameter:String):String
		{
			var value:int = _item[parameter];
			if (value == 0)
				return '';
			
			var format:String = '<font size="12">{0}: <b>{1}{2}{3}</b></font><br/>'
			var sign:String = (value > 0 && !_item.isBody) ? '+' : '';
			var paramName:String = _robotsBundle.messages[parameter]; 
			var percent:String = (_item.percent) ? '%': '';			
			var result:String = Strings.substitute(format,
				paramName, sign, String(value), percent);
			
			return result;
		}
		
		public function get htmlText():String
		{
			 return _field.htmlText;
		}
		
	}
}