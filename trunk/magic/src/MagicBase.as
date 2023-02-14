package
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.location.LocationBase;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class MagicBase extends Sprite
	{
		public function MagicBase()
		{
			Security.allowDomain('*');
		}
		
		public function execute():void
		{
		}
	}
}