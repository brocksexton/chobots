package com.kavalok.robotCombat.commands
{
	import assets.combat.McMinusPoints;
	import assets.combat.McPlusPoints;
	
	import com.kavalok.robotCombat.view.ModuleViewBase;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.MoviePlayer;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class ShowPointsCommand extends ModuleCommandBase
	{
		private var _points:int;
		private var _coords:Point;
		private var _content:MovieClip;
		
		public function ShowPointsCommand(points:int, coords:Point)
		{
			_points = points;
			_coords = coords;
			super();
		}
		
		override public function execute():void
		{
			createContent();
			var moviePlayer:MoviePlayer = new MoviePlayer(_content);
			moviePlayer.completeEvent.addListener(onMovieComplete);
			moviePlayer.play();
		}
		
		private function onMovieComplete(sender:Object):void
		{
			GraphUtils.detachFromDisplay(_content);
			dispathComplete();	
		}
		
		private function createContent():void
		{
			_content = (_points > 0)
				? new McPlusPoints()
				: new McMinusPoints();
				
			var field:TextField = _content.textClip.pointsField;
			ModuleViewBase.initTextField(field);
			field.text = (_points > 0 ? "+" : "") + String(_points);
			
			combat.root.addChild(_content);
			GraphUtils.setCoords(_content, _coords);
		}
		
	}
}