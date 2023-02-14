package com.kavalok.location.modifiers
{
	import com.kavalok.flash.playback.MovieClipPlayer;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class DoorsModifier implements IClipModifier
	{
		private static const DOORS_PREFIX : String = "doors_";
		
		public function DoorsModifier()
		{
		}
		
		public function accept(clip : MovieClip):Boolean
		{
			return getDoor(clip) != null;
		}
			
		public function modify(clip : MovieClip):void
		{
			clip.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			clip.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			getDoor(clip).gotoAndStop(1);
		}
		
		private function getDoor(clip : MovieClip) : MovieClip
		{
			var config : String = GraphUtils.getConfigString(clip);
			if(config == null)
				return null;
				
			var parameters:Object = GraphUtils.getParameters(clip); 
			var doorsName:String = ('doors' in parameters)
				? parameters['doors']
				: DOORS_PREFIX + config;
				
			var doors : MovieClip = clip.parent[doorsName];
			return doors;
		}
			

		private function onMouseOver(event : MouseEvent) : void
		{
			var door : MovieClip = getDoor(MovieClip(event.currentTarget));
			if(door.player)
				door.player.stop();
			door.play();
		}

		private function onMouseOut(event : MouseEvent) : void
		{
			var door : MovieClip = getDoor(MovieClip(event.currentTarget));
			if(door.player)
				door.player.stop();
			var player : MovieClipPlayer = new MovieClipPlayer(door);
			door.player = player;
			player.playInterval(door.currentFrame, 1);
		}

	}
}