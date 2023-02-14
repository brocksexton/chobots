package com.kavalok.char.actions
{
	import com.kavalok.Global;
	
	public class PropertyActionBase extends CharActionBase
	{
		override public function execute():void
		{
			doAction(Global);
		}
		
		protected function doAction(object:Object):void
		{
			if (_parameters.sender == Global.charManager.charId)
			{
				setProperty(object);
			}
			else
			{
				try
				{
					setProperty(object);
				}
				catch (e:Error)
				{
				}
			}
		}
		
		protected function setProperty(topObject:Object):void
		{
			var object:Object = topObject;
			var path:Array = String(_parameters.path).split('.');
			var property:String = path[path.length - 1];
			var value:* = _parameters.value; 
			
			for (var i:int = 0; i < path.length - 1; i++)
			{
				object = object[path[i]];
			}
			
			if (value == 'true')
				value = true;
			else if (value == 'false')
				value = false;
			else if (String(value).charAt(0) == "'")
				value = String(value).substr(1);
			else
				value = parseFloat(String(value));
			
			object[property] = value;
		}
	}
}