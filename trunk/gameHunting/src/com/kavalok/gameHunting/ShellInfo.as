package com.kavalok.gameHunting
{
	
	/**
	 * ...
	 * @author Canab
	 */
	public class ShellInfo
	{
		public var classSpriteIn:Class;
		public var classSpriteOut:Class;
		public var startVy:Number;
		public var g:Number;
		public var health:int;
		public var showTime:Number; //seconds
		public var classSoundGo:Class;
		public var classSoundHit:Class;
		
		public function ShellInfo(startVy:Number, g:Number, health:int, showTime:Number,
			spriteIn:Class, spriteOut:Class,
			soundGo:Class, soundHit:Class)
		{
			this.startVy = startVy;
			this.g = g;
			this.health = health;
			this.showTime = showTime;
			this.classSpriteIn = spriteIn;
			this.classSpriteOut = spriteOut;
			this.classSoundGo = soundGo;
			this.classSoundHit = soundHit;
		}
		
	}
	
}