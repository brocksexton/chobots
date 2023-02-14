package org.goverla.serialization.serializers
{
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.interfaces.IRequirement;
	
	import mx.collections.IList;

	public class ListSerializer extends BaseCollectionSerializer
	{
		override public function get serializerRequirement():IRequirement
		{
			return new ClassRequirement(IList);
		}
		
		override protected function getChild(object:Object, index:int):Object {
			return IList(object).getItemAt(index);
		}
		
		override protected function getLength(object:Object):int {
			return IList(object).length;
		}
		
	}
}