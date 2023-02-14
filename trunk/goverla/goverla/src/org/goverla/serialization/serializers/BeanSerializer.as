package org.goverla.serialization.serializers
{
	import org.goverla.collections.ArrayList;
	import org.goverla.interfaces.IRequirement;
	import org.goverla.serialization.interfaces.ISerializableBean;
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.serializers.requirements.PrimitiveTypeRequirement;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.utils.comparing.NotEqualsRequirement;
	import org.goverla.utils.comparing.NotRequirement;
	import org.goverla.utils.comparing.RequirementsCollection;
	
	public class BeanSerializer implements ISerializer
	{
		public function toXML(object:Object, rootSerializer:ISerializer):XML
		{
			var result : XML = SerializationUtil.createEmptyNode(ReflectUtil.getFullTypeName(object));
			var ignoredProperties : ArrayList;
			if(object is ISerializableBean) {
				ignoredProperties = ISerializableBean(object).ignoredProperties;
			} else {
				ignoredProperties = new ArrayList();
			}
			ignoredProperties.addItems(this.ignoredProperties);
			
			for each(var property : String in ReflectUtil.getReadWritePropertiesByInstance(object)) {
				if(ignoredProperties.contains(property)) 
					continue;
					
				var child : XML = rootSerializer.toXML(object[property], rootSerializer);
				child.setName(property);
				result.appendChild(child);
			}
			return result;
		}
		
		public function get serializerRequirement() : IRequirement {
			return new RequirementsCollection([
				new NotRequirement(new PrimitiveTypeRequirement())
				, new NotEqualsRequirement(null)]);
		}
		
		protected function get ignoredProperties() : ArrayList {
			return new ArrayList();
		}

		
	}
}