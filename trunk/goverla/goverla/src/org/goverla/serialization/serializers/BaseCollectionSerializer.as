package org.goverla.serialization.serializers
{
	import mx.utils.StringUtil;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.errors.NotImplementedError;
	import org.goverla.interfaces.IRequirement;
	import org.goverla.serialization.constants.SerializationConstants;
	import org.goverla.serialization.interfaces.ISerializer;
	
	

	public class BaseCollectionSerializer extends BeanSerializer implements ISerializer
	{
		override public function toXML(object:Object, rootSerializer:ISerializer):XML
		{
			
			var result : XML = super.toXML(object, rootSerializer);//SerializationUtil.createEmptyNode(ReflectUtil.getFullTypeName(object));
			result.@collection = true.toString();
			for(var i : int = 0; i < getLength(object); i++) {
				var child : XML = rootSerializer.toXML(getChild(object, i), rootSerializer);
				child.setName(StringUtil.substitute(SerializationConstants.COLLECTION_NODE_NAME_FORMAT, i));
				result.appendChild(child);
			}
			return result;		
		}
		
		override public function get serializerRequirement():IRequirement
		{
			throw new NotImplementedError("BaseCollectionSerializer is abstract class");
			return null;
		}
		
		override protected function get ignoredProperties():ArrayList {
			return new ArrayList(["list"]);
		}
		
		protected function getLength(object : Object) : int {
			throw new NotImplementedError("BaseCollectionSerializer is abstract class");
		}

		protected function getChild(object : Object, index : int) : Object {
			throw new NotImplementedError("BaseCollectionSerializer is abstract class");
		}		
	}
}