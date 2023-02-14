package common.utils
{
	import common.comparing.IRequirement;
	import common.comparing.PropertyRequirement;
	
	/**
	* ...
	* @author Canab
	*/
	public class ArrayUtil
	{
		static public function findByProperty(source:Array, property:String, value:Object):Object
		{
			return getFirstRequired(source, new PropertyRequirement(property, value));
		}
		
		static public function getByProperty(source:Array, property:String, value:Object):Array
		{
			return getRequired(source, new PropertyRequirement(property, value));
		}
		
		static public function getRequired(source:Object, requirement:IRequirement):Array
		{
			var result:Array = [];
			for each (var item:Object in source)
			{
				if (requirement.accept(item))
					result.push(item);
			}
			return result;
		}
		
		static public function getFirstRequired(source:Object, requirement:IRequirement):Object
		{
			var result:Object = null;
			for each (var item:Object in source)
			{
				if (requirement.accept(item))
				{
					result = item;
					break;
				}
			}
			return result;
		}
		
		static public function hasRequired(source:Object, requirement:IRequirement):Object
		{
			return Boolean(getFirstRequired(source, requirement));
		}
		
		static public function removeItem(source:Array, item:Object):void
		{
			source.splice(source.indexOf(item), 1);
		}
		
	}
	
}