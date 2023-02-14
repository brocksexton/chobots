package org.goverla.utils.comparing {
	
	import org.goverla.interfaces.IRequirement;
	import org.goverla.utils.Objects;

	public class UniqueFieldRequirement extends UniqueItemRequirement implements IRequirement	{
		
		private var _fieldName : String;
		
		public function UniqueFieldRequirement(fieldName : String) {
			_fieldName = fieldName;
		}
		
		override protected function getValue(source:Object):Object
		{
			return Objects.getProperty(source, _fieldName);
		}
		
	}
	
}