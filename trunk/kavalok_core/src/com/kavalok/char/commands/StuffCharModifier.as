package com.kavalok.char.commands
{
	import com.kavalok.Global;
	
	import flash.utils.getDefinitionByName;
	
	
	public class StuffCharModifier extends StuffCommandBase
	{
		private var _className:String;
		
		override public function apply():void
		{
			var fieldName:String = 'modifier';
			var modifierName:String = parameters[fieldName];
			_className = 'com.kavalok.char.modifiers::' + modifierName;
			
			delete parameters[fieldName];
			parameters.noTimeLimit = true;
			
			Global.charManager.addModifier(_className, parameters);
		}
		
		override public function restore():void
		{
			Global.charManager.removeModifier(_className);
		}
	}
}