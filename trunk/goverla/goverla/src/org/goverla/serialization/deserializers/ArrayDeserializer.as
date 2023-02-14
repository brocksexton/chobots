package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.deserializers.requirements.NodeToInstanceRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.utils.Objects;
	import org.goverla.interfaces.IRequirement;
	
	

	public class ArrayDeserializer extends BaseCollectionDeserializer implements IDeserializer
	{
		override public function get deserializerRequirement():IRequirement
		{
			return new NodeToInstanceRequirement(new ClassRequirement(Array));
		}
		
		override protected function addChild(parent:Object, child:Object, nodeName : String):void {
			Objects.castToArray(parent).push(child);
		}
	}
}