package org.goverla.utils {

	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.constants.MetadataNames;
	import org.goverla.constants.ReflectionConstants;
	import org.goverla.errors.IllegalArgumentError;
	import org.goverla.errors.ReflectionError;
	import org.goverla.interfaces.IRequirement;
	import org.goverla.serialization.common.TrueRequirement;
	import org.goverla.utils.common.FieldDescription;
	import org.goverla.utils.comparing.XmlAttributeRequirement;
	
	public class ReflectUtil {
		
		public static function getChildren(source : Object) : ArrayCollection {
			if (source is ArrayCollection) {
				return source as ArrayCollection;
			} else if (source is Array) {
				return new ArrayCollection(source as Array);
			} else {
				var result : ArrayCollection = new ArrayCollection();
				var properties : ArrayCollection = getFieldsAndPropertiesByInstance(source);
				for each (var property : String in properties) {
					result.addItem(source[property]);
				}
				return result;
			}
		}
		
		public static function createInstance(type : Class, arguments : Array = null) : Object {
			if (arguments == null || arguments.length == 0) {
				return new type();
			} else if (arguments.length == 1) {
				return new type(arguments[0]);
			} else if (arguments.length == 2) {
				return new type(arguments[0], arguments[1]);
			} else if (arguments.length == 3) {
				return new type(arguments[0], arguments[1], arguments[2]);
			} else if (arguments.length == 4) {
				return new type(arguments[0], arguments[1], arguments[2], arguments[3]);
			} else if (arguments.length == 5) {
				return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]);
			} else {
				throw new IllegalArgumentError("For now only 5 arguments in constructor are supported");
			}
			

		}
		
		public static function isDynamic(object : Object) : Boolean {
			var description : XML = describeType(object);
			return String(description.@isDynamic) == Objects.TRUE_STRING;
		}
		
		public static function copyFieldsAndProperties(source : Object, target : Object) : void {
			var sourceMembers : ArrayCollection = getFieldsAndPropertiesByInstance(source);
			//var targetMembers : ArrayCollection = getFieldsAndPropertiesByInstance(target);
			for each (var property : String in sourceMembers) {
				try 
				{
					target[property] = source[property];
				}
				catch(e : Error)
				{
					//OK
				}
			}
			
		}		
		
		public static function getEvents(type : Class) : ArrayList {
			var list : XMLList = describeType(type).factory.metadata.(@name == "Event");
			var result : ArrayList = new ArrayList();
			for each (var child : XML in list) {
				var arg : XMLList = child.arg.(@key == "name");
				result.addItem(String(arg[0].@value));
			}
			return result;
		}
		
		public static function getType(instance : Object, applicationDomain : ApplicationDomain = null) : Class {
			if (applicationDomain == null) {
				applicationDomain = ApplicationDomain.currentDomain;
			}
			return getTypeByName(getQualifiedClassName(instance), applicationDomain);	
		}		

		public static function getTypeByName(typeName : String, applicationDomain : ApplicationDomain = null) : Class {
			if (applicationDomain == null) {
				applicationDomain = ApplicationDomain.currentDomain;
			}

			var result : Class;
			if (typeName == "null") {
				result = null;
			} else {
				result = Objects.castToClass(applicationDomain.getDefinition(typeName));
			}
			return result;	
		}		
		
		public static function getTypeName(instance : Object) : String {
			var nameWithContext : String = getFullTypeName(instance);
			return nameWithContext.substr(nameWithContext.lastIndexOf(".") + 1);
		}
		
		public static function normalizeTypeName(typeName : String) : String {
			return typeName.replace("::", ".");
			
		}		
		
		public static function getFullTypeName(instance : Object) : String {
			var description : XML = describeType(instance);
			var nameWithContext : String = description.@name;
			return normalizeTypeName(nameWithContext);
		}
		
		public static function hasFieldByInstance(instance : Object, name : String) : Boolean {
			return getFieldsByInstance(instance).contains(name);
		}

		public static function hasPropertyByInstance(instance : Object, name : String) : Boolean {
			return getPropertiesByInstance(instance).contains(name);
		}		
		
		public static function hasMethodByInstance(instance : Object, name : String) : Boolean {
			return getMethodsByInstance(instance).contains(name);
		}
		
		public static function getFieldsDescriptionsByInstance(instance : Object, applicationDomain : ApplicationDomain = null) : ArrayCollection {
			if (applicationDomain == null) {
				applicationDomain = ApplicationDomain.currentDomain;
			}

			var result : ArrayCollection = new ArrayCollection();
			 
			if (!ObjectUtil.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = new ArrayCollection(getFieldsDescriptions(instance, description, applicationDomain));
			}
			
			return result;
		}
		
		public static function getFieldsAndPropertiesByInstance(instance : Object) : ArrayList {
			var result : ArrayList = new ArrayList();
			result.addItems(getFieldsByInstance(instance));
			result.addItems(getPropertiesByInstance(instance));
			return result;
		}
		
		
		public static function getFieldsByInstance(instance : Object) : ArrayCollection {
			var result : ArrayCollection = new ArrayCollection();
			 
			if (!ObjectUtil.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = new ArrayCollection(getFields(instance, description));
			}
			
			return result;
		}
		
		public static function getReadWritePropertiesByInstance(instance : Object) : ArrayCollection {
			var result : ArrayCollection = new ArrayCollection();
			 
			if (!ObjectUtil.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = new ArrayCollection(getAccessors(instance
					, description
					, new XmlAttributeRequirement("access", ReflectionConstants.READ_WRITE)));
			}
			
			return result;
		}
		
		public static function getPropertiesByInstance(instance : Object) : ArrayCollection {
			var result : ArrayCollection = new ArrayCollection();
			 
			if (!ObjectUtil.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = new ArrayCollection(getAccessors(instance, description));
			}
			
			return result;
		}
		public static function getMethodsByInstance(instance : Object) : ArrayCollection {
			var result : ArrayCollection = new ArrayCollection();
			 
			if (!ObjectUtil.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = new ArrayCollection(getMethods(instance, description));
			}
			
			return result;
		}
		
		public static function getClassMetadata(obj : Object) : Object {
			var result : Object = {};
			var classInfo : XML = mx.utils.DescribeTypeCache.describeType(obj).typeDescription;
			for each (var metadata : XML in XMLList(classInfo.metadata)) {
				result[metadata.@name] = {};
				for each (var arg : XML in XMLList(metadata.arg)) {
					result[metadata.@name][arg.@key] = String(arg.@value);
				}
			}
			return result;
		}
		
		public static function getMetadata(obj : Object, propName : String, metadataName : String) : ArrayCollection {
			var result : ArrayCollection = new ArrayCollection();
			
			var isExists : Boolean = ObjectUtil.hasMetadata(obj, propName, metadataName);
			if (isExists) {
				var propertyMetadata : Object = ObjectUtil.getClassInfo(obj)[MetadataNames.METADATA][propName];
				var values : Object = propertyMetadata[metadataName];
				if (values != null) {
					for each (var property : String in values) {
						result.addItem(property);
					}
				}
			}
			
			return result;
		}
		

		public static function getMethodName(instance : Object, method : Function) : String {
			var result : String;
			var methods : ArrayCollection = getMethodsByInstance(instance);
			for (var i : int = 0; i < methods.length; i++) {
				if (instance[methods.getItemAt(i)] == method) {
					result = methods.getItemAt(i) as String;
					break;
				}
			}
			
			if (result == null) {
				throw new ReflectionError(StringUtil.substitute("No method [{0}] in object [{1}]", method, instance.toString()));
			}
			
			return result;
		}

		private static function getFieldsDescriptions(instance : Object, description : XML, applicationDomain : ApplicationDomain = null) : Array {
			if (applicationDomain == null) {
				applicationDomain = ApplicationDomain.currentDomain;
			}

			var result : Array = new Array();
			
			if (XMLList(description.@name).toString() != "Object") {
				for each (var variable : XML in description.variable) {
					var name : String = XMLList(variable.@name).toString();
					var className : String = XMLList(variable.@type).toString();
					result.push(new FieldDescription(name, getTypeByName(className, applicationDomain)));
				}
	
				for each (var factory : XML in description.factory) {
					result.concat(getFieldsDescriptions(instance, factory, applicationDomain));
				}
			}
			
			for (var field : String in instance) {
				result.push(new FieldDescription(field, getType(instance[field], applicationDomain)));
			}

			return result;
		}
		
		private static function getFields(instance : Object, description : XML) : Array {
			var result : Array = new Array();
			
			if (XMLList(description.@name).toString() != "Object") {
				for each (var variable : XML in description.variable) {
					result.push(XMLList(variable.@name).toString());
				}
	
				for each (var factory : XML in description.factory) {
					result.concat(getFields(instance, factory));
				}
			} 

			for (var field : String in instance) {
				result.push(field);
			}

			return result;
		}

		private static function getAccessors(instance : Object, description : XML, requirement : IRequirement = null) : Array {
			if (requirement == null) {
				requirement = new TrueRequirement();
			}
			
			var result : Array = new Array();
			
			for each (var accessor : XML in description.accessor) {
				if (requirement.meet(accessor)) {
					result.push(XMLList(accessor.@name).toString());
				}
			}
			
			for each (var factory : XML in description.factory) {
				result.concat(getAccessors(instance, factory, requirement));
			}
			return result;
		}
		
		private static function getMethods(instance : Object, description : XML) : Array {
			var result : Array = new Array();
			
			for each (var method : XML in description.method) {
				result.push(XMLList(method.@name).toString());
			}
			
			for each (var factory : XML in description.factory) {
				result.concat(getMethods(instance, factory));
			}
			
			return result;
		}	
			
	}

}