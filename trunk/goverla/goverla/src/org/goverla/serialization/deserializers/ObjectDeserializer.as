package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.common.TrueRequirement;
	import org.goverla.serialization.deserializers.requirements.NodeToInstanceRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.serializers.requirements.PrimitiveTypeRequirement;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.comparing.NotRequirement;
	import org.goverla.interfaces.IRequirement;
	import org.goverla.serialization.XMLSerializer;
	
	

	public class ObjectDeserializer implements IDeserializer
	{
		public function get deserializerRequirement():IRequirement
		{
			return new NotRequirement(new NodeToInstanceRequirement(new PrimitiveTypeRequirement()));
		}
		
		public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			var result : Object = SerializationUtil.newInstance(object);
			if(object.@id != null) {
				XMLSerializer(rootDeserializer).addCircularReference(object.@id, result);
			}
			for each(var node : XML in object.children()) {
				addChild(result, rootDeserializer.toObject(node, rootDeserializer), node.name());
			}
			return result;
		}
		
		protected function addChild(parent : Object, child : Object, nodeName : String) : void {
			parent[nodeName] = child;
		}
	}
}