package org.goverla.serialization.serializers
{
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.utils.comparing.ClosureRequirement;
	import org.goverla.interfaces.IRequirement;

	public class DynamicObjectSerializer extends BeanSerializer implements ISerializer
	{
		override public function toXML(object:Object, rootSerializer:ISerializer):XML
		{
			var result : XML = super.toXML(object, rootSerializer);
			for(var property : String in object)
			{
				var child : XML = rootSerializer.toXML(object[property], rootSerializer);
				child.setName(property);
				result.appendChild(child);
			}
			
			return result;
		}
		
		override public function get serializerRequirement():IRequirement
		{
			return new ClosureRequirement(ReflectUtil.isDynamic);
		}
		
	}
}