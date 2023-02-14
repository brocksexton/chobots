package com.kavalok.location.commands
{
	import com.kavalok.char.CharStates;
	import com.kavalok.char.LocationChar;
	
	import flash.geom.Point;
	
	import gs.TweenLite;
	import gs.easing.Expo;
	
	public class MoveCharCommand extends RemoteLocationCommand
	{
		public var charId:String;
		public var x:int;
		public var y:int
		
		public function MoveCharCommand(charId:String = null, position:Point = null)
		{
			if (charId)
				this.charId = charId;
			if (position)
			{
				this.x = position.x;
				this.y = position.y;
			}
			super();
		}
		
		override public function execute():void
		{
			var char:LocationChar = location.chars[charId];
			if (char)
			{
				char.stopMoving();
				TweenLite.to(char.content, 1.0, {x: x, y: y, ease: Expo.easeOut});
				if (char.isUser)
					saveState();
				if (char.pet)
					location.movePet(char, location.getPetPosition(char.position));
			}
		}
		
		private function saveState():void
		{
			var state:Object = {};
			state[CharStates.X] = x;
			state[CharStates.Y] = y;
			location.sendUserState(null, state);
		}
	
	}
}