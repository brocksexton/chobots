package com.kavalok.robotCombat.view
{
	import com.kavalok.Global;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.robotCombat.Combat;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import com.kavalok.utils.GraphUtils;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	public class ModuleViewBase
	{
		public function ModuleViewBase()
		{
		}
		
		public function get combat():Combat
		{
			 return Combat.instance;
		}
		
		public function get bundle():ResourceBundle
		{
			 return Global.resourceBundles.robots;
		}
		
		static public function initButton(button:SimpleButton):void
		{
			var fields:Array = GraphUtils.extractTextFieldsFromButton(button);
			for each (var field:TextField in fields)
			{
				initTextField(field);	
			}
		}
		
		static public function initTextField(field:TextField):void
		{
			var format:TextFormat = field.getTextFormat(0, 1);
			format.font = 'ModuleFont';
			
			field.embedFonts = true;
			field.selectable = false;
			field.defaultTextFormat = format;
			field.setTextFormat(format);
			field.text = '';
			field.cacheAsBitmap = true;
			field.mouseEnabled = false;
			field.antiAliasType = AntiAliasType.ADVANCED;
		}

	}
}