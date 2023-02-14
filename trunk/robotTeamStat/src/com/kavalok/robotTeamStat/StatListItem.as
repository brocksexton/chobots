package com.kavalok.robotTeamStat
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotTeamScoreTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.IListItem;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.SpriteDecorator;
	import com.kavalok.utils.Strings;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import robotStat.McListItem;
	
	public class StatListItem implements IListItem
	{
		private var _clickEvent:EventSender = new EventSender(StatListItem);
		
		private var _score:RobotTeamScoreTO;
		private var _content:McListItem = new McListItem();
		private var _bundle:ResourceBundle = Global.resourceBundles.robots;
		
		public function StatListItem(score:RobotTeamScoreTO)
		{
			_score = score;
			initialize();
			refresh();
		}
		
		private function initialize():void
		{
			selected = false;
			RobotTeamStat.instance.initTextFields(_content);
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
			_content.nameCaption.text = Strings.substitute(_bundle.messages.teamNameFormat, _score.name);
			_content.totalCaption.text = String(_score.numCombats);
			_content.winCaption.text = String(_score.numWin);
			_content.opaqueClip.visible = _score.rate % 2 == 0;
			
			SpriteDecorator.decorateColor(_content.colorClip, _score.color, 0);
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }
		
		public function get content():Sprite { return _content; }
		public function get score():RobotTeamScoreTO { return _score; }
	}
}