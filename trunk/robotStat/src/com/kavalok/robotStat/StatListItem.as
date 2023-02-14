package com.kavalok.robotStat
{
	import com.kavalok.dto.robot.RobotScoreTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.IListItem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import robotStat.McListItem;
	
	public class StatListItem implements IListItem
	{
		private var _clickEvent:EventSender = new EventSender(StatListItem);
		
		private var _score:RobotScoreTO;
		private var _content:McListItem = new McListItem();
		
		public function StatListItem(score:RobotScoreTO)
		{
			_score = score;
			initialize();
			refresh();
		}
		
		private function initialize():void
		{
			selected = false;
			RobotStat.instance.initTextFields(_content);
			_content.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			_clickEvent.sendEvent(this);
		}
		
		public function set selected(value:Boolean):void
		{
			 if (value)
			 	_content.gotoAndStop(2);
			 else
			 	_content.gotoAndStop(1);
		}
		
		private function refresh():void
		{
			_content.rateCaption.text = String(_score.rate);
			_content.nameCaption.text = _score.name;
			_content.levelCaption.text = String(_score.level);
			_content.totalCaption.text = String(_score.numCombats);
			_content.winCaption.text = String(_score.numWin);
			_content.opaqueClip.visible = _score.rate % 2 == 0;
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }
		
		public function get content():Sprite { return _content; }
		public function get score():RobotScoreTO { return _score; }
	}
}