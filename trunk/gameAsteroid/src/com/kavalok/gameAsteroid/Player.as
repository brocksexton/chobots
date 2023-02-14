
package com.kavalok.gameAsteroid
{
	import com.kavalok.games.GameObject;
	import com.kavalok.utils.GraphUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;

	public class Player extends GameObject
	{
		static public const STATE_NONE:int			= -1;
		static public const STATE_MOVE:int 			= 0;
		static public const STATE_DEACTIVATED:int	= 2;
		
		public var destroyed:Boolean;
		
		private var _state:int = STATE_MOVE;
		private var _zone:Sprite;
		
		public function Player(content:MovieClip, zone:Sprite)
		{
			super(content);
			_zone = zone;
			bounds = zone.getBounds(zone.parent);
			content.stop();
			radius = 0.3 * content.width;
		}
		
		override public function processMov():void
		{
			super.processMov();
			
			if (_state == STATE_MOVE)
			{
				var x:Number = content.x;
				var dx:Number = (content.parent.mouseX - content.x) / Config.PLYER_SPEED;
				content.x += dx;
				
				content.x = GraphUtils.claimRange(
					content.x,
					bounds.left,
					bounds.right
				)
				
				content.filters = [new BlurFilter(Math.abs(x - content.x), 0)];
			}
			else if (_state == STATE_DEACTIVATED)
			{
				if (!content.hitTestObject(_zone))
				{
					destroyed = true;
					_state = STATE_NONE;
				}
			}
		}
		
		public function deactivate():void
		{
			_state = STATE_DEACTIVATED;
			content.filters = [];
		}
		
		public function get state():int { return _state; }
		
	}
	
}
