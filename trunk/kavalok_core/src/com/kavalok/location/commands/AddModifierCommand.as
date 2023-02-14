package com.kavalok.location.commands
{
	import com.kavalok.Global;
	
	public class AddModifierCommand extends RemoteLocationCommand
	{
		
		public var aClass:String;
		
		override public function execute():void
		{
			var clasName:String = 'com.kavalok.char.modifiers::' + aClass;
			Global.charManager.addModifier(clasName, {});
		}
	}
}