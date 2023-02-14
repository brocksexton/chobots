package com.kavalok.location.modifiers
{
	import com.kavalok.Global;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.competitions.ScoreBoardView;
	import com.kavalok.services.CompetitionDataService;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CompetitionModifier
	{
		public static const PREFIX : String = "competition_"; 
		private static const SCORES_COUNT : int = 10;
		private static const MARGIN : int = 30;
		
		private var _object : DisplayObject;
		private var _scoreBoard : ScoreBoardView;
		private var _name : String;
		
		public function CompetitionModifier(object : DisplayObject)
		{
			_object = object;
			_object.alpha = 0;
			_name = object.name.split("_")[1];
			createScoreBoard();
			refresh();
		}
		

		
		private function refresh() : void
		{
			new CompetitionDataService(onGetMyResult).getMyCompetitionResult(_name, 0, SCORES_COUNT);
			
		}
		private function onGetMyResult(result : Array) : void
		{
			ToolTips.unRegisterObject(_object);
			if(result)
			{
				_scoreBoard.content.visible = true;
				_scoreBoard.refresh(result);
			}
			else
			{
				_scoreBoard.content.visible = false;
				ToolTips.registerObject(_object, "noCompetitions", ResourceBundles.COMPETITIONS);
			}
			
		}
		private function createScoreBoard() : void
		{
			_scoreBoard = new ScoreBoardView(_name);
			_object.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			var position : Point = GraphUtils.transformCoords(new Point(0, 0), _object, Global.root);
			
			if(_object.x > KavalokConstants.SCREEN_WIDTH / 2)
				_scoreBoard.content.x = position.x - _scoreBoard.content.width - _object.width - MARGIN;
			else 
				_scoreBoard.content.x = position.x;
			
			_scoreBoard.content.y = position.y;
			
		}
		private function onMouseOver(event : MouseEvent) : void
		{
			refresh();
			Global.topContainer.addChild(_scoreBoard.content);
			GraphUtils.claimBounds(_scoreBoard.content, KavalokConstants.SCREEN_RECT);
			
			_object.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_object.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		private function onMouseOut(event : MouseEvent) : void
		{
			_object.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_object.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			Global.topContainer.removeChild(_scoreBoard.content);
			
		}

	}
}