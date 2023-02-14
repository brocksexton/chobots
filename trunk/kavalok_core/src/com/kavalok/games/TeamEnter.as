package com.kavalok.games
{
	import com.kavalok.location.entryPoints.TeamEntryPoint;
	
	import flash.utils.Dictionary;
	
	public class TeamEnter extends GameEnter
	{
		private var _teams : Dictionary = new Dictionary();
		private var _team : uint;
		
		public function TeamEnter(gameName:String, team:uint, entryPoint : TeamEntryPoint, params : Object)
		{
			super(gameName, null, entryPoint, params);
			_team = team;
		}
		
		override protected function refreshStartEnabled() : void
		{
			entryPoint.startEnabled = remote.connectedChars.length > 0;			
		}
		
		override protected function processGameParameters(parameters:Object):void
		{
			parameters.team = _team;
		}
	}
}