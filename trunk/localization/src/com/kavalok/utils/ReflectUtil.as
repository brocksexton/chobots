package com.kavalok.utils {

	import com.kavalok.collections.ArrayList;
	import com.kavalok.interfaces.IRequirement;
	import com.kavalok.utils.common.FieldDescription;
	import com.kavalok.utils.comparing.EqualsRequirement;
	
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	public class ReflectUtil {
		
		public static function isDynamic(object : Object) : Boolean {
			var description : XML = describeType(object);
			return String(description.@isDynamic) == Objects.TRUE_STRING;
		}
		
		public static function copyFieldsAndProperties(source : Object, target : Object) : void {
			var sourceMembers : ArrayList = getFieldsAndPropertiesByInstance(source);
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
		
		public static function getFieldsDescriptionsByInstance(instance : Object, applicationDomain : ApplicationDomain = null) : Array {
			if (applicationDomain == null) {
				applicationDomain = ApplicationDomain.currentDomain;
			}

			var result : Array = new Array();
			 
			if (!Objects.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = getFieldsDescriptions(instance, description, applicationDomain);
			}
			
			return result;
		}
		
		public static function getFieldsAndPropertiesByInstance(instance : Object) : ArrayList {
			var result : ArrayList = new ArrayList();
			result.addItems(getFieldsByInstance(instance));
			result.addItems(getPropertiesByInstance(instance));
			return result;
		}
		
		
		public static function getFieldsByInstance(instance : Object) : Array {
			var result : Array = new Array();
			 
			if (!Objects.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = getFields(instance, description);
			}
			
			return result;
		}
		
		public static function getPropertiesByInstance(instance : Object) : Array {
			var result : Array = new Array();
			 
			if (!Objects.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = getAccessors(instance, description);
			}
			
			return result;
		}
		public static function getMethodsByInstance(instance : Object) : Array {
			var result : Array = new Array();
			 
			if (!Objects.isSimple(instance)) {
				var description : XML = describeType(instance);
				result = getMethods(instance, description);
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
			var result : Array = new Array();
			
			for each (var accessor : XML in description.accessor) {
				if (requirement == null || requirement.meet(accessor)) {
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