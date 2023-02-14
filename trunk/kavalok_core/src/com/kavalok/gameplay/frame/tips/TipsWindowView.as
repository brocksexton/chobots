package com.kavalok.gameplay.frame.tips
{
	import com.kavalok.Global;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.gameplay.controls.TextScroller;
	import com.kavalok.gameplay.controls.ToggleButton;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.UserServiceNT;
	import com.kavalok.text.TextPlayer;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TipsWindowView extends FlashViewBase
	{
		private static const resourceBundle : ResourceBundle = Localiztion.getBundle("tips");
		
		private static const IMAGE_TAG : String = "<img src='{0}' align='left' hspace='4' vspace='4'/>";
		private static const INITIAL_COORDS : Point = new Point(280, 70);
		
		private var _content : McTipsWindow;
		private var _tips : Array = [];
		private var _currentTipIndex : uint = 0;
		private var _text : String = "";
		private var _neverShowButton : ToggleButton;
		private var _button : MovieClip;
		private var _intro : Boolean;
		private var _scroller : TextScroller;
		private var _textPlayer : TextPlayer;
		
		public function TipsWindowView(button : MovieClip)
		{
			McTipIcons;
			_content = new McTipsWindow();
			_button = button;
			_button.gotoAndStop(0);
			super(_content);
			_content.x = INITIAL_COORDS.x;
			_content.y = INITIAL_COORDS.y;
			new DragManager(_content, _content.headerButton, KavalokConstants.SCREEN_RECT);
			_neverShowButton = new ToggleButton(_content.neverShowButton);

			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
			_content.previousButton.addEventListener(MouseEvent.CLICK, onPreviousClick);
			_content.neverShowButton.addEventListener(MouseEvent.CLICK, onNeverShowClick);
			_content.introButton.addEventListener(MouseEvent.CLICK, onIntroClick);
			
			GraphUtils.stopAllChildren(_content.snail);
			_scroller = new TextScroller(_content.scroller, _content.tipField);
			_textPlayer = new TextPlayer(_content.tipField);
			_content.tipField.text = "";
			_textPlayer.change.addListener(_scroller.updateScrollerVisible);
			_textPlayer.finish.addListener(onFinishTalk);			
			
			visible	= false;
			new ResourceScanner().apply(content);
			refreshButtons();
			
			
			Global.locationManager.locationChange.addListener(onLocationChange);
			helpEnabled = Global.charManager.helpEnabled;
			
			if(Global.charManager.firstLogin)
				_intro = true;
		}
		
		
		public function set helpEnabled(value:Boolean) : void
		{
			_neverShowButton.toggle = !value;
		}
		public function get visible():Boolean
		{
			 return content.visible;
		}
		
		public function set visible(value:Boolean):void
		{
			if(visible == value)
				return;
				
			content.visible = value;
			if(!value)
			{
				onFinishTalk();
				GraphUtils.stopAllChildren(_content.snail);
			}
			else
			{
				showCurrentTip();
			}
		}
		
		private function getIntroTips() : Array
		{
			var result : Array = [];
			var i : uint = 0;
			while(resourceBundle.messages["intro"+i])
			{
				result.push("intro"+i);
				i++;
			}
			return result;
		}
		
		public function addTip(tipId : String) : void
		{
			if (Global.startupInfo.isBot)
				return;
			
			var isNew : Boolean = false;
			var setActiveTip:Boolean = true;
			
			if(_tips.indexOf(tipId) != -1)
			{
				_tips.splice(_tips.indexOf(tipId), 1);
			}
			else
			{
				isNew = true;
			}
			
			if(_intro)
			{
				_intro = false;
				setActiveTip = false;
				showIntroTips();
			}
	
			_tips.push(tipId);
			
			if(setActiveTip)
			{
				_currentTipIndex = _tips.length - 1;
				showCurrentTip();
			}
			
			refreshButtons();
			if(!_neverShowButton.toggle && Global.frame.tipsVisible)
				visible = true;
				
			if(_neverShowButton.toggle && !visible && isNew)
				_button.play();
		}

		private function showIntroTips() : void
		{
			var introTips:Array = getIntroTips();
			
			for each(var tip : String in introTips)
			{
				addTip(tip);
			}
			_currentTipIndex = _tips.indexOf(introTips[0]);
			showCurrentTip();
			refreshButtons();
		}
		
		private function showCurrentTip() : void
		{
			if (!visible)
				return;
			
			_button.gotoAndStop(0);
			var tipId : String = _tips[_currentTipIndex];
			var tip : String = Strings.removeReturns(resourceBundle.messages[tipId]);
			if(!tip)
				return;
			_content.tipField.text = "";
			_text = "";
			var parts : Array = tip.split(/(%.*?%)/);
			var tipParts : ArrayList = new ArrayList();
			for each(var part : String in parts)
			{
				if(!Strings.startsWidth(part, "%"))
				{
					tipParts.addItems(part.split(""));
				}
				else
				{
					var tag : String = Strings.substitute(IMAGE_TAG, Strings.removeSymbols(part, "%"));
					tipParts.addItem(tag);
				}
			}
			_textPlayer.playParts(tipParts);
			GraphUtils.playAllChildren(_content.snail);
		}
		
		private function refreshButtons() : void
		{
			_content.previousButton.visible = _currentTipIndex > 0;
			_content.nextButton.visible = _currentTipIndex < _tips.length - 1;
		}
		
		
		private function onIntroClick(event : MouseEvent) : void
		{
			showIntroTips();
		}
		
		private function onNeverShowClick(event : MouseEvent) : void
		{
			new UserServiceNT().setHelpEnabled(!_neverShowButton.toggle);
		}
		
		private function onLocationChange() : void
		{
			var currentLocation : String = Global.locationManager.locationId;
			if(resourceBundle.messages[currentLocation])
			{
				addTip(currentLocation);
			}
		}
		
		private function changeTip(difference : int) : void
		{
			_currentTipIndex += difference;
			showCurrentTip();
			refreshButtons();
		}
		private function onPreviousClick(event : MouseEvent) : void
		{
			changeTip(-1);
		}
		private function onNextClick(event : MouseEvent) : void
		{
			changeTip(1);
		}
		private function onCloseClick(event : MouseEvent) : void
		{
			visible = false;
		}
		
		private function onFinishTalk() : void
		{
			_content.snail.mouth.gotoAndStop(1);
		}
	}
}