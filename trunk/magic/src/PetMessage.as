package
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.Strings;
	
	public class PetMessage extends MagicBase
	{
		public function PetMessage()
		{
		}
		
		override public function execute():void
		{
			var loc:LocationBase = Global.locationManager.location;
			var char:LocationChar = loc.chars[charName];
			if (char && char.pet)
				char.pet.chatMessage.show(null, Strings.replaceCharacters(message, ['_'], [' ']));
		}
		
		public function get charName():String
		{
			 return loaderInfo.parameters.charName;
		}
		
		public function get message():String
		{
			 return loaderInfo.parameters.message;
		}

	}
}