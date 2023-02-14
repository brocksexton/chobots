
package com.kavalok.gameAsteroid
{
	import com.kavalok.games.GameObject;
	import flash.display.Sprite;

	public class Shell extends GameObject
	{
		public var destroyed:Boolean;
		private var _zone:Sprite;
		
		public function Shell(player:GameObject, zone:Sprite)
		{
			super(new McShell());
			
			_zone = zone;
			
			content.x = player.content.x;
			content.y = player.content.y - 0.3 * player.content.height;
			content.cacheAsBitmap = true;
			
			v.y = -Config.SHELL_SPEED;
			
			weight = 50;
		}
		
		override public function processMov():void
		{
			super.processMov();
			destroyed = !content.hitTestObject(_zone);
		}
		
	}
	
}
