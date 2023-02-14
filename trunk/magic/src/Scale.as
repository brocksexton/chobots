package
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.Sprite;
	
	public class Scale extends MagicBase
	{
		private var _counter:int = 10;
		
		public function Scale()
		{
			super();
		}
		
		override public function execute():void
		{
			var user:LocationChar = Global.locationManager.location.user;
			new SpriteTweaner(user.model, {y: 0}, int(Math.random() * 15), null, moveUp);
		}
		
		private function moveUp(target:Sprite):void
		{
			new SpriteTweaner(target, {scaleX: 1.5, scaleY:1.5}, 10, null, moveDown);
		}
		
		private function moveDown(target:Sprite):void
		{
			if (--_counter > 0)
				new SpriteTweaner(target, {scaleX: 1, scaleY:1}, 10, null, moveUp);
			else
				new SpriteTweaner(target, {scaleX: 1, scaleY:1}, 10);
		}
		
		
		
	}
}