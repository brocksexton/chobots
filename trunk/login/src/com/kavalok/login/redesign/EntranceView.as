package com.kavalok.login.redesign
{
	import com.kavalok.URLHelper;
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ViewStackPage;
	import com.kavalok.gameplay.controls.EnabledButton;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import gs.TweenLite;
	import gs.easing.Expo;

	public class EntranceView extends ViewStackPage
	{
		private var _content : McEntrance;
		
		private var _registerEvent : EventSender = new EventSender();
		private var _loginEvent : EventSender = new EventSender();
		private var _slideContent:Sprite;
		private var _loader:SafeLoader;
		private var _bundle:ResourceBundle = Localiztion.getBundle(Modules.LOGIN);
		private var _dx:int;
		private var _nextX:int;
		
		public function EntranceView(content:McEntrance)
		{
			super(_content = content);
			_content.contentMask.visible = false;
		//	_content.playBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOverPlay);
		//	_content.playBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOutPlay);
			_content.playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
			_content.registerButton.addEventListener(MouseEvent.CLICK, onRegisterClick);
			new EnabledButton(_content.playButton);
			new EnabledButton(_content.registerButton);
			
			_dx = _content.pointerClip.x - _content.buttonsClip.x;
			initButtons();
		}
		
		override public function onHide():void
		{
			removeSlideContent();
		}
		

		
		override public function onShow():void
		{
			showPage(1);
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			removeSlideContent();
			loginEvent.sendEvent();
		}
		
		private function onRegisterClick(e:MouseEvent):void
		{
			removeSlideContent();
			registerEvent.sendEvent();
		}
		
		private function initButtons():void
		{
			for (var i:int = 0; i < _content.buttonsClip.numChildren; i++)
			{
				var button:Sprite = _content.buttonsClip.getChildAt(i) as Sprite;
				button.cacheAsBitmap = true;
				button.buttonMode = true;
				button.addEventListener(MouseEvent.CLICK, onButonClick);
			}
		}
		
		private function onButonClick(e:MouseEvent):void
		{
			var name:String = DisplayObject(e.currentTarget).name;
			var num:int = parseInt(name.replace('button', ''));
			showPage(num);
		}
		
		
		private function showPage(pageNum:int):void
		{
			_content.numberClip.gotoAndStop(pageNum);
			_bundle.registerTextField(_content.descriptionField, 'entrancePic' + pageNum);
			
			if (_loader)
			{
				_loader.completeEvent.removeListener(onLoadComplete);
				_loader.cancelLoading();
			}
			
			removeSlideContent();
			
			var url:String = URLHelper.resourceURL('pic' + pageNum, Modules.LOGIN);
			_loader = new SafeLoader();
			_loader.completeEvent.addListener(onLoadComplete);
			_loader.load(new URLRequest(url));
			_nextX = _content.buttonsClip.x + _content.buttonsClip['button' + pageNum].x + _dx;
		}
		
		private function onLoadComplete():void
		{
			TweenLite.to(_content.pointerClip, 0.75, 
				{
					x: _nextX,
					ease: Expo.easeOut
				});
			
			_slideContent = _loader.content as Sprite;
			_content.addChild(_slideContent);
			_slideContent.x = _content.contentMask.x;
			_slideContent.y = _content.contentMask.y;
		}
		
		
		private function removeSlideContent():void
		{
			if (_slideContent)
			{
				GraphUtils.detachFromDisplay(_slideContent);
				_slideContent = null;
			}
		}
		
		public function set registrationEnabled(value : Boolean) : void
		{
			_content.registerButton.visible = value;
			_content.registerField.visible = value; 
		}
		
		public function get loginEvent() : EventSender
		{
			return _loginEvent;
		}
		
		public function get registerEvent() : EventSender
		{
			return _registerEvent;
		}
		
	}
}