package
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.char.LocationChar;
	
	public class Inv extends MagicBase
	{
		private var _counter:int = 10;
		
		public function Inv()
		{
			super();
		}
		
		override public function execute():void
		{
			for each (var locChar:LocationChar in Global.locationManager.location.chars)
			{
				locChar.char.body = body;
				locChar.refreshModel();
			}
		}
		
		public function get body():String
		{
			 return loaderInfo.parameters.body;
		}
	}
}