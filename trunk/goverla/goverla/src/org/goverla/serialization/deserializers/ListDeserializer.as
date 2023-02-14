package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.deserializers.requirements.NodeToInstanceRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.interfaces.IRequirement;
	
	
	
	import mx.collections.IList;

	public class ListDeserializer extends BaseCollectionDeserializer implements IDeserializer
	{
		override public function get deserializerRequirement():IRequirement
		{
			return new NodeToInstanceRequirement(new ClassRequirement(IList));
		}
		
		override protected function addChild(parent:Object, child:Object, nodeName : String):void {
			IList(parent).addItem(child);
		}
		
		
	}
}