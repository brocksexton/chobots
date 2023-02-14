package com.kavalok.utils {

	import com.kavalok.collections.ArrayList;
	import com.kavalok.interfaces.IConverter;
	import com.kavalok.interfaces.IRequirement;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	public class Arrays {
		
		public static function mix(source : ArrayList) : ArrayList {
			for (var i : uint = 0; i < source.length; i++) {
				replaceItems(source, int(Math.random() * source.length), int(Math.random() * source.length));
			}
			return source;
		}
		
		public static function randomItem(source : Array) : * {
			return source[Maths.random(source.length)];
		}
		
		public static function randomItems(source:Array, count:int):Array
		{
			var result:Array = [];
			var selection:Array = [];
			
			for (var i:int = 0; i < count; i++)
			{
				var index:int = Maths.random(source.length);
				
				while(selection.indexOf(index) >= 0)
				{
					index++;
					if (index == source.length)
						index = 0;
				}
				
				result.push(source[index]);
				selection.push(index);
			}
			
			return result;
		}
		
		public static function replaceItems(source : ArrayList, firstIndex : int, secondIndex : int) : void {
			var firstItem : Object = source.getItemAt(firstIndex);
			var secondItem : Object = source.setItemAt(firstItem, secondIndex);
			source.setItemAt(secondItem, firstIndex);
		}
		
		
		public static function forceArray(source : Object) : Array {
			return source == null ? [] : Objects.castToArray(source);
		}
		
		public static function itemsEqual(firstList : ArrayList, secondList : ArrayList) : Boolean {
			if (firstList == secondList) { 
				return true;
			}
			
			if (firstList.length != secondList.length) { 
				return false;
			}

			var result : Boolean = true;
			for (var i : int = 0; i < firstList.length; i++) {
				if (firstList.getItemAt(i) != secondList.getItemAt(i)) {
					result = false;
					break;
				}
			}
			return result;
		}
		
		public static function insertAll(target : Array, list : Array) : Array {
			for (var i : uint = 0; i < list.length; i++) {
				target.push(list[i]); 
			}
			return target;
		}

		public static function subList(source : ArrayList, beginIndex : uint, length : uint) : ArrayList {
			var result : ArrayList = new ArrayList();
			for (var i : Number = 0; i < length; i++) {
				result.addItem(source.getItemAt(beginIndex + i)); 
			}
			return result;
		}

		public static function removeItem(item : Object, source : Array) : void {
			source.splice(source.indexOf(item), 1);
		}
		
		public static function removeItems(source : ArrayList, beginIndex : uint, count : uint ) : void {
			for (var i : uint = 0; i < count; i++) {
				source.removeItemAt(beginIndex); 
			}
		}

		public static function removeAll(source : Array, list : Array) : void {
			for (var i : uint = 0; i < list.length; i++) {
				source.removeItemAt(source.getItemIndex(list[i])); 
			}
		}
		
		public static function getConverted(list : Array, converter : IConverter) : ArrayList {
			var result : ArrayList = new ArrayList();
			for (var i : Number = 0; i < list.length; i++) {
				result.addItem(converter.convert(list[i])); 
			}
			return result;
		}
		
		public static function safeFirstByRequirement(collection : Array, requirement : IRequirement) : Object {
			var result : Object = null;
			try	{
				result = firstByRequirement(collection, requirement);
			}
			catch (e : Error) {}
			
			return result;
		}
		
		public static function firstByRequirement(collection : Array, requirement : IRequirement) : Object {
			return getByRequirement(collection, requirement).getItemAt(0);
		}		
		
//		public static function removeByRequirements(collection : Array, requirements : Array) : ArrayCollection {
//			var reqs : RequirementsCollection = new RequirementsCollection(requirements);
//			return removeByRequirement(collection, reqs);
//		}		
		
		public static function removeByRequirement(collection : Array, requirement : IRequirement) : Array {
			var items : ArrayList = getByRequirement(collection, requirement);
			removeAll(collection, items); 
			return items;
		}		

		public static function getByRequirement(collection:Object, requirement : IRequirement) : ArrayList {
			var result : ArrayList = new ArrayList();
			for each(var item : Object in collection) {
				if(requirement.meet(item)) {
					result.addItem(item);
				}						
			}
			return result;
		}
		
//		public static function firstByRequirements(collection : Object, requirements : Array) : Object {
//			return getByRequirements(collection, requirements).getItemAt(0);
//		}
//		
//		public static function getByRequirements(collection : Object, requirements : Array) : ArrayList {
//			return getByRequirement(collection, new RequirementsCollection(requirements));		
//		}
	
//		public static function containsByRequirements(collection : Object, requirements : Array) : Boolean {
//			var reqs : RequirementsCollection = new RequirementsCollection(requirements);
//			return containsByRequirement(collection, reqs);
//		}		
//		
		public static function containsByRequirement(collection : Array, requirement : IRequirement) : Boolean {
			var result : ArrayList = getByRequirement(collection, requirement);
			return result.length > 0;		
		}
	
		public static function indexByRequirement(collection : Array, requirement : IRequirement) : int {
			var item : Object = firstByRequirement(collection, requirement);
			return collection.indexOf(item);
		}

		public static function findSimilarElements(list1 : ArrayList, list2 : ArrayList) : ArrayList {
			var result : ArrayList = new ArrayList();
			for (var i : Number = 0; i < list1.length; i++) {
				if (list2.contains(list1.getItemAt(i))) {
					var index : Number = list2.getItemIndex(list1.getItemAt(i));
					result.addItem(list2.getItemAt(index));
				}
			}
			return result;
		}
		
		public static function merge(firstListCollectionView : Array, secondListCollectionView : Array) : ArrayList {
			var result : ArrayList = new ArrayList();
			insertAll(result, firstListCollectionView);			
			insertAll(result, secondListCollectionView);			
			return result;
		}

		public static function clone(source : Array) : Array {
			var result : Array = new Array();
			for (var i : int = 0; i < source.length; i++) {
				result[i] = source[i];
			}
			return result;
		}
	
		public static function objectToArray(source : Object) : Array {
			var result : Array = new Array();
			for (var property : String in source) {
				result.push(source[property]);
			}
			return result;
		}
		
		static public function findByProperty(collection:Object, property:String, value:*):Array
		{
			return getByRequirement(collection,
				new PropertyCompareRequirement(property, value));
		}
		
		static public function lastItem(source:Array):Object
		{
			return source[source.length - 1];
		}
		
	}
	
}