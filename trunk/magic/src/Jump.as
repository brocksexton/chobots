package
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.Sprite;
	
	public class Jump extends MagicBase
	{
		public function Jump()
		{
			super();
		}
		
		override public function execute():void
		{
			var user:LocationChar = Global.locationManager.location.user;
			new SpriteTweaner(user.model, {y: 0}, Math.random() * 10, null, moveUp);
		}
		
		private function moveUp(target:Sprite):void
		{
			new SpriteTweaner(target, {y: -100}, 15);
			new SpriteTweaner(target, {rotation: 180}, 15, null, moveDown);
		}
		
		private function moveDown(target:Sprite):void
		{
			target.rotation = -179;
			new SpriteTweaner(target, {y: 0}, 15);
			new SpriteTweaner(target, {rotation: 0}, 15);
		}
		
		
		
	}
}