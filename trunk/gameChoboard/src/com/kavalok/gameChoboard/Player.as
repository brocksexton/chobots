
package com.kavalok.gameChoboard
{
	import com.kavalok.games.GameObject;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;

	public class Player extends GameObject
	{
		public var ready:Boolean = false;
		
		private var _gravity:Number = Config.GRAVITY_START;
		private var _accY:Number = Config.PLAYER_ACCY_START;
		private var _accX:Number = Config.PLAYER_ACCX_START;
		
		public function Player(content:McPlayer)
		{
			content.model.stop();
			super(content);
			
			dcc.x = Config.PLAYER_DCCX_START;
			dcc.y = Config.PLAYER_DCCY_START;
		}
		
		public function addLevel():void
		{
			_gravity += Config.GRAVITY_INCR;
			_accY = _gravity * 2;
			_accX *= 1.1;
		}
		
		public function control():void
		{
			var ky:Number = GraphUtils.claimRange(
				(content.parent.mouseY - content.y) / Config.PlAYER_SENSETIVITY, -1, 1);
			
			var kx:Number = GraphUtils.claimRange(
				(content.parent.mouseX - content.x) / Config.PlAYER_SENSETIVITY, -1, 1);
			
			acc.x = _accX * kx;
			acc.y = _accY * ky + _gravity;
			
			content.rotation = 20 * (kx + ky);
		}
		
		public function blink():void
		{
			McPlayer(content).model.play();
		}
		
	}
	
}
