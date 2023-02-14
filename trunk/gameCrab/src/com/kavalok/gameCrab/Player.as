package com.kavalok.gameCrab
{
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	import flash.ui.Keyboard;

	public class Player extends Car
	{
		
		public function Player()
		{
			maxV = Config.PLAYER_MAXV;
			accV = Config.PLAYER_ACCV;
			accR = Config.PLAYER_ACCR;
		}
		
		public function control():void
		{
			if (Global.keyboard.isKeyPressed(Keyboard.UP))
			{
				speed = GraphUtils.claimRange(speed + accV, 0, maxV);
			}
			if (Global.keyboard.isKeyPressed(Keyboard.DOWN))
			{
				speed = GraphUtils.claimRange(speed - accV, 0, maxV);
			}
			
			if (Global.keyboard.isKeyPressed(Keyboard.LEFT))
				content.rotation -= accR;
			
			if (Global.keyboard.isKeyPressed(Keyboard.RIGHT))
				content.rotation += accR;
		}
		
	}
	
}
