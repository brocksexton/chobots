package com.kavalok.gameCrab
{
	import com.kavalok.Global;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Ball extends ObjectBase
	{
		static private const soundEvent:String = 'SOUND';
		
		public function Ball()
		{
			dcc = Config.BALL_DCC;
		}
		
		override public function initialzie():void
		{
			super.initialzie();
			
			borderReverse = true;
			content.addEventListener(soundEvent, playSound);
		}
		
		private function playSound(e:Event):void
		{
			//Global.playSound();
		}
		
	}
	
}
