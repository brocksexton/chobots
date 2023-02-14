package org.goverla.serialization.deserializers
{
	import org.goverla.errors.AbstractMethodError;
	import org.goverla.serialization.constants.SerializationConstants;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.interfaces.IRequirement;
	
	import mx.utils.StringUtil;
	
	

	public class BaseCollectionDeserializer extends ObjectDeserializer
	{
		override public function get deserializerRequirement():IRequirement
		{
			throw new AbstractMethodError(BaseCollectionDeserializer, "deserializerRequirement");
			return null;
		}
		
		override public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			var result : Object = SerializationUtil.newInstance(object);
			for each(var node : XML in object.children()) {
				var regexp : RegExp = new RegExp(SerializationConstants.COLLECTION_NODE_NAME_PATTERN, "");
				var child : Object = rootDeserializer.toObject(node, rootDeserializer);
				if(regexp.test(node.name())) {
					addChild(result, child, node.name());
				} else {
					super.addChild(result, child, node.name());
				}
			}
			return result;
		}
		
		override protected function addChild(parent : Object, child : Object, nodeName : String) : void {
			throw new AbstractMethodError(BaseCollectionDeserializer, "setChildAt");
		}
		
	}
}