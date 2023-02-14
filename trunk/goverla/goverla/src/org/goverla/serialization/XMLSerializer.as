package org.goverla.serialization
{
	import org.goverla.collections.ArrayList;
	import org.goverla.collections.HashMap;
	import org.goverla.errors.IllegalStateError;
	import org.goverla.interfaces.IRequirement;
	import org.goverla.serialization.common.TrueRequirement;
	import org.goverla.serialization.deserializers.ArrayDeserializer;
	import org.goverla.serialization.deserializers.BooleanDeserializer;
	import org.goverla.serialization.deserializers.ClassDeserializer;
	import org.goverla.serialization.deserializers.ListDeserializer;
	import org.goverla.serialization.deserializers.NullDeserializer;
	import org.goverla.serialization.deserializers.NumberDeserializer;
	import org.goverla.serialization.deserializers.ObjectDeserializer;
	import org.goverla.serialization.deserializers.StringDeserializer;
	import org.goverla.serialization.deserializers.XMLTypeDeserializer;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.serializers.ArraySerializer;
	import org.goverla.serialization.serializers.BeanSerializer;
	import org.goverla.serialization.serializers.ClassSerializer;
	import org.goverla.serialization.serializers.DynamicObjectSerializer;
	import org.goverla.serialization.serializers.ListSerializer;
	import org.goverla.serialization.serializers.NullSerializer;
	import org.goverla.serialization.serializers.PrimitiveTypeSerializer;
	import org.goverla.serialization.serializers.StringSerializer;
	import org.goverla.serialization.serializers.XmlTypeSerializer;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.Objects;
	import org.goverla.utils.ReflectUtil;
	
	

	public class XMLSerializer implements ISerializer, IDeserializer
	{
		private var _serializers : HashMap = new HashMap();
		private var _deserializers : HashMap = new HashMap();
		private var _circularReferences : ArrayList = new ArrayList();
		private var _deserializedReferences : HashMap = new HashMap();
		
		public function XMLSerializer() {
			registerSerializer(new XmlTypeSerializer());
			registerSerializer(new ArraySerializer());
			registerSerializer(new ListSerializer());
			registerSerializer(new ClassSerializer());
			registerSerializer(new StringSerializer());
			registerSerializer(new PrimitiveTypeSerializer());
			registerSerializer(new DynamicObjectSerializer());
			registerSerializer(new BeanSerializer());
			registerSerializer(new NullSerializer());
			
			registerDeserializer(new NullDeserializer());
			registerDeserializer(new XMLTypeDeserializer());
			registerDeserializer(new ArrayDeserializer());
			registerDeserializer(new ListDeserializer());
			registerDeserializer(new ClassDeserializer());
			registerDeserializer(new NumberDeserializer());
			registerDeserializer(new BooleanDeserializer());
			registerDeserializer(new StringDeserializer());
			registerDeserializer(new ObjectDeserializer());
		}
		
		public function get serializerRequirement() : IRequirement {
			return new TrueRequirement();
		}
		
		public function get deserializerRequirement() : IRequirement {
			return new TrueRequirement();
		}
		
		public function serialize(object:Object):XML {
			_circularReferences.removeAll();
			var result : XML = toXML(object, null);
			_circularReferences.removeAll();
			return result;
		}
		
		public function deserialize(node:XML):Object {
			_deserializedReferences.clear();
			var result : Object = toObject(node, null);
			_deserializedReferences.clear();
			return result;
		}
		
		public function toXML(object:Object, rootSerializer:ISerializer):XML
		{
			var result : XML;
			if(!Objects.isPrimitive(object) && object != null) {
				if(!_circularReferences.contains(object)) {
					_circularReferences.addItem(object);
					var index : uint = _circularReferences.length - 1;
					result = doToXML(object, rootSerializer);
					result.@id = index;
				} else {
					result = SerializationUtil.createEmptyNode(ReflectUtil.getFullTypeName(object));
					result.@id = _circularReferences.getItemIndex(object);
				}
			} else {
				result = doToXML(object, rootSerializer);
			}
			return result;
		}
		
		public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			if(object.@id != undefined && _deserializedReferences.containsKey(int(object.@id))) {
				return _deserializedReferences.getItem(int(object.@id));
			} else {
				var deserializer : IDeserializer = getDeserializer(object);
				return deserializer.toObject(object, this);
			}
		}
		
		public function registerSerializer(serializer : ISerializer) : void {
			_serializers.addItem(serializer.serializerRequirement, serializer);
		}

		public function registerDeserializer(deserializer : IDeserializer) : void {
			_deserializers.addItem(deserializer.deserializerRequirement, deserializer);
		}
		
		public function addCircularReference(id : int, reference :  Object) : void {
			_deserializedReferences.addItem(id, reference);
		}
		
		private function doToXML(object:Object, rootSerializer:ISerializer) : XML {
			var serializer : ISerializer = getSerializer(object);
			return serializer.toXML(object, this);
		}
		
		private function getSerializer(object : Object) : ISerializer {
			for(var i : uint = 0; i < _serializers.keys.length; i++) {
				var req : IRequirement = IRequirement(_serializers.keys[i]);
				if(req.meet(object)) {
					return ISerializer(_serializers.getItem(req));
				}
			}
			throw new IllegalStateError("There is no serializer for this object");
		}
		
		private function getDeserializer(node : XML) : IDeserializer {
			for(var i : uint = 0; i < _deserializers.keys.length; i++) {
				var req : IRequirement = IRequirement(_deserializers.keys[i]);
				if(req.meet(node)) {
					return IDeserializer(_deserializers.getItem(req));
				}
			}
			throw new IllegalStateError("There is no deserializer for this node");
		}
		
	}
}