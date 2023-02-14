package org.goverla.css
{
	import org.goverla.collections.TypedArrayCollection;
	import org.goverla.utils.Arrays;
	import org.goverla.utils.comparing.PropertyCompareRequirement;
	import org.goverla.interfaces.IRequirement;
	import org.goverla.collections.HashMap;
	import org.goverla.utils.Objects;

	public class CSSDeclaration extends TypedArrayCollection
	{
		
		private var _aliases : HashMap = new HashMap();
		
		public function CSSDeclaration()
		{
			super(CSSStylesGroup);
		}
		
		public function apply() : void {
			for each(var group : CSSStylesGroup in this) {
				group.apply();
				applyAliases(group);
			}
		}
		
		public function addAlias(styleName : String, ... alias) : void {
			_aliases.addItem(styleName, alias);
		}
		
		public function getStylesGroup(name : String) : CSSStylesGroup {
			var result : CSSStylesGroup;
			var requirement : IRequirement = new PropertyCompareRequirement("name", name);
			try {
				result = CSSStylesGroup(Arrays.firstByRequirement(this, requirement));
			} catch (error : RangeError) {
				result = null;
			}
			
			return result;
		}

		override public function toString() : String {
			var result : String = "";
			for(var i : int = 0; i < this.length; i++) {
				var group : CSSStylesGroup = CSSStylesGroup(this.getItemAt(i));
				result += group.toString();
			}
			return result;
		}
		
		private function applyAliases(group : CSSStylesGroup) : void {
			if(_aliases.containsKey(group.name)) {
				var realName : String = group.name;
				var aliases : Array = Objects.castToArray(_aliases.getItem(group.name));
				for each(var alias : String in aliases) {
					group.name = alias;
					group.apply();
				}
				group.name = realName;
			}
			
		}
	}
}