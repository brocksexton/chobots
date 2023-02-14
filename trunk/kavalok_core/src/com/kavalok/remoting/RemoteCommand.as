package com.kavalok.remoting
{
	import com.kavalok.collections.ArrayList;
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.utils.ReflectUtil;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class RemoteCommand
	{
		public var className:String = getQualifiedClassName(this);
		
		private var _id:Number = -1;
		
		public function get id():Number
		{
			 return _id;
		}
		
		public function set id(value:Number):void
		{
			 _id = value;
		}
		
		static public function createInstance(properties:Object):RemoteCommand
		{
			var cmdClass:Class = Class(getDefinitionByName(properties.className));
			var cmd:RemoteCommand = new cmdClass();
			
			for (var prop:String in properties)
			{
				cmd[prop] = properties[prop];
			}
			
			return cmd;
		}
		
		public function getProperties():Object
		{
			var fields:ArrayList = ReflectUtil.getFieldsAndPropertiesByInstance(this);
			var properties:Object = {};
			
			for each (var field:String in fields)
			{
				if (this[field])
				{
					properties[field] = this[field];
				}
			}
			
			return properties;
		}
		
		public function execute():void
		{
			throw new NotImplementedError();
		}

	}
}