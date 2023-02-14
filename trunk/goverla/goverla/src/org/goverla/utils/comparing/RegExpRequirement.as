package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IRequirement;
	import org.goverla.utils.Objects;

	public class RegExpRequirement implements IRequirement
	{
		private var _regexp : RegExp;
		
		public function RegExpRequirement(regexp : RegExp)
		{
			super();
			_regexp = regexp;
		}

		public function meet(object:Object):Boolean
		{
			return _regexp.test(Objects.castToString(object));
		}
		
	}
}