package com.kavalok.location.entryPoints
{
	import com.kavalok.games.GameEnter;
	import com.kavalok.games.TeamEnter;
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.MovieClip;

	public class TeamEntryPoint extends GameEntryPoint
	{
		private static const TEAM_GAME_SESSION_INDEX : uint = 4;
		private static const TEAM_INDEX : uint = 2;
		
		public function TeamEntryPoint(location:LocationBase)
		{
			super(location);
		}
		
		override protected function get prefix():String
		{
			return "team_";
		}
		
		override protected function getStartButton(parts: Array) : MovieClip
		{
			var name : String = "start_" + addSessionPostfix(parts[GAME_NAME_INDEX], parts[TEAM_GAME_SESSION_INDEX]);
			return MovieClip(GraphUtils.getFirstChild(_location.content, new PropertyCompareRequirement("name", name)));
		}

		override protected function createGameEnter(entryName:String):GameEnter
		{
			var parts : Array = entryName.split("_");
			var gameName : String = parts[GAME_NAME_INDEX];
			return new TeamEnter(gameName, parts[TEAM_INDEX], this, currentParams);
		}
		
	}
}