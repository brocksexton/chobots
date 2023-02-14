package com.kavalok.robotTeamStat
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotTeamScoreTO;
	import com.kavalok.gameplay.commands.RetriveStuffCommand;
	import com.kavalok.gameplay.controls.ListBox;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.robots.Robot;
	import com.kavalok.services.RobotServiceNT;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import robotStat.McStatView;
	
	public class StatView
	{
		static private const TOP0_COUNT:int = 5;
		static private const TOP1_COUNT:int = 25;
		static private const TOP0_ITEM:String = 'robo_jacket_team';
		static private const TOP1_ITEM:String = 'flag_robots_team';
		
		private var _content:McStatView;
		private var _loading:LoadingSprite;
		private var _statList:ListBox;
		private var _statBox:ScrollBox;
		private var _selection:StatListItem;
		private var _bundle:ResourceBundle = Global.resourceBundles.robots;
		private var _resultList:Array;
		private var _myResult:RobotTeamScoreTO;
		private var _priceName:String;
		
		public function StatView()
		{
			createContent();
			createList();
			loadData();
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.priseButton.addEventListener(MouseEvent.CLICK, onPriseClick);
		}
		
		private function createList():void
		{
			_statList = new ListBox();
			_content.addChild(_statList.content);
			GraphUtils.setCoords(_statList.content, _content.maskClip);
			var scroller:Scroller = new Scroller(null, _content.scrollerClip);
			_statBox = new ScrollBox(_statList.content, _content.maskClip, scroller);
		}
		
		private function createContent():void
		{
			_content = new McStatView();
			_loading = new LoadingSprite(_content.maskClip.getBounds(_content));
			_content.addChild(_loading);
			
			RobotTeamStat.instance.initTextFields(_content);
			
			_content.rateCaption.text = _bundle.messages.rate;
			_content.nameCaption.text = _bundle.messages.teamName;
			_content.totalCaption.text = _bundle.messages.total;
			_content.winCaption.text = _bundle.messages.win;
			
			if (Global.charManager.robotTeam.teamExists)
			{
				_content.myNameCaption.text = _bundle.messages.teamName + ':';
				_content.myNameField.text = Strings.substitute(
					_bundle.messages.teamNameFormat, Global.charManager.robotTeam.owner);
				
				_content.myRateCaption.text = _bundle.messages.rate + ':';
				_content.myTotalCaption.text = _bundle.messages.total + ':';
				_content.myWinCaption.text = _bundle.messages.win + ':';
			}
			else
			{
				_content.myNameCaption.visible = false;
				_content.myRateCaption.visible = false;
				_content.myTotalCaption.visible = false;
				_content.myWinCaption.visible = false;
			}
			
			_content.priseButton.visible = false;
			_content.priceCaption.text = '';
		}
		
		private function refresh():void
		{
			if (_myResult)
			{
				_content.myTotalField.text = String(_myResult.numCombats)
				_content.myWinField.text = String(_myResult.numWin);
			}
			refreshRate();
		}
		
		private function refreshRate():void
		{
			var rate:int = Arrays.indexByRequirement(_resultList,
				new PropertyCompareRequirement('name', Global.charManager.robotTeam.owner));
			if (rate >= 0)
			{
				rate += 1;
				_content.myRateField.text = String(rate);
				if (rate <= TOP0_COUNT && !Global.charManager.stuffs.stuffExists(TOP0_ITEM))
				{
					_priceName = TOP0_ITEM;
					_content.priseButton.visible = true;
					_content.priceCaption.text = Strings.substitute(
						_bundle.messages.prise, String(TOP0_COUNT));
				}
				else if (rate <= TOP1_COUNT && !Global.charManager.stuffs.stuffExists(TOP1_ITEM))
				{
					_priceName = TOP1_ITEM;
					_content.priseButton.visible = true;
					_content.priceCaption.text = Strings.substitute(
						_bundle.messages.prise, String(TOP1_COUNT));
				}
				else
				{
					_priceName = null;
					_content.priseButton.visible = false;
					_content.priceCaption.text = "";
				}
			}
		}
		
		private function loadData():void
		{
			new RobotServiceNT(onGetData).getTeamTopScores();
		}
		
		private function onGetData(result:Array):void
		{
			_myResult = result.pop();
			_resultList = result;
			GraphUtils.detachFromDisplay(_loading);
			populateList(_resultList);
			refresh();
		}
		
		private function populateList(scores:Array):void
		{
			var rate:int = 0;
			for each (var score:RobotTeamScoreTO in scores)
			{
//for (var i:int = 0; i < 20; i++)
//{
				score.rate = ++rate;
				var item:StatListItem = new StatListItem(score);
				item.clickEvent.addListener(onItemClick);
				if (score.name == Global.charManager.robotTeam.owner)
					selection = item;
				_statList.addItem(item);
//}
			}
			_statList.refresh();
			_statBox.refresh();
		}
		
		private function onItemClick(sender:StatListItem):void
		{
			selection = sender;
		}
		
		public function set selection(value:StatListItem):void
		{
			 if (_selection)
			 	_selection.selected = false;
			 _selection = value;
			 if (_selection)
			 	_selection.selected = true;
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			RobotTeamStat.instance.closeModule();
		}
		
		private function onPriseClick(e:MouseEvent):void
		{
			var command:RetriveStuffCommand = new RetriveStuffCommand(_priceName, null);
			command.completeEvent.addListener(onGetStuff);
			command.execute();
		}
		
		private function onGetStuff(sender:RetriveStuffCommand):void
		{
			refresh();
			RobotTeamStat.instance.closeModule();
		}
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		public function get robot():Robot
		{
			 return Global.charManager.robot;
		}

	}
}