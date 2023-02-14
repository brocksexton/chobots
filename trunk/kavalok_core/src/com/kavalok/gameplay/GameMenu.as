package com.kavalok.gameplay
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dialogs.McMenu;
	import com.kavalok.gameplay.commands.ChangePasswordCommand;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.localization.Localiztion;
	import flash.display.Sprite;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	import fl.events.ColorPickerEvent;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import fl.controls.ColorPicker;
	import flash.utils.setInterval;
	import fl.controls.CheckBox;
	
	public class GameMenu
	{
		private var _content:McMenu = new McMenu();
		private var colourSprite:Sprite;
		private var uiColler:uint = uint("0x" + Global.charManager.uiColour.toString(16));
		private var _nightCheckBox:StateButton = new StateButton(_content.nightCheckBox);;
		private var _soundVolume:Scroller = new Scroller(_content.mcSoundVolume);
		private var _musicVolume:Scroller = new Scroller(_content.mcMusicVolume);
		private var _charNamesCheckBox:StateButton = new StateButton(_content.charNamesCheckBox);
		private var _requestCheckBox:StateButton = new StateButton(_content.requestCheckBox);
		private var _locationCheckBox:StateButton = new StateButton(_content.locationCheckBox);
		private var _darknessCheckBox:StateButton = new StateButton(_content.darknessCheckBox);
		private var _brbButton:SimpleButton = new SimpleButton(_content.brbButton);
		
		private var _quality:Array = [_content.quality0, _content.quality1, _content.quality2,]
		
		private var _locales:Object = {uaUA: _content.uaUA, enUS: _content.enUS, deDE: _content.deDE, ruRU: _content.ruRU}
		
		public function GameMenu()
		{
			checkLock();
			_content.uiColPick.selectedColor = Global.charManager.uiColourint;
			_content.uiColPick.addEventListener(ColorPickerEvent.CHANGE, onColPick);
			_content.uiColDef.visible = Global.charManager.isCitizen;
			_content.uiColDef.selected = Global.charManager.defaultFrame;
			_content.uiColDef.addEventListener(MouseEvent.CLICK, onColDef);

			ToolTips.registerObject(_content.mLockButton, "Your volume is unlocked. Lock it if you don't want \nmoderators to be able to change your volume.");
				ToolTips.registerObject(_content.unlockButton, "Your volume is locked. Unlock it if you want \nmoderators to be able to change your volume.");

//			_content.deDE.mouseChildren = false;
//			_content.deDE.mouseEnabled = false;
			_content.uiColPick.visible = Global.charManager.isCitizen;
			_content.textCitizen.visible = !Global.charManager.isCitizen;
			_soundVolume.position = Global.soundVolume / 100.0;
			_soundVolume.changeEvent.addListener(onSoundVolume);
			
			_musicVolume.position = Global.musicVolume / 100.0;
			_musicVolume.changeEvent.addListener(onMusicVolume);
			
			_charNamesCheckBox.state = Global.showCharNames ? 2 : 1;
			_charNamesCheckBox.stateEvent.addListener(onCharNames);
			
			_requestCheckBox.state = Global.acceptRequests ? 2 : 1;
			_requestCheckBox.stateEvent.addListener(onRequestClick);
			
			_nightCheckBox.state = !!Global.acceptNight ? 2 : 1;
			_nightCheckBox.stateEvent.addListener(onNightClick);
			
			_locationCheckBox.state = Global.charManager.publicLocation ? 2 : 1;
			_locationCheckBox.stateEvent.addListener(onLocationClick);

			
			_brbButton.addEventListener(MouseEvent.CLICK, onBrbClick);
			
			_content.passwordButton.addEventListener(MouseEvent.CLICK, onPasswordClick);
			_content.lockButton.addEventListener(MouseEvent.CLICK, onLockClick);
			_content.mc_okButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.mLockButton.addEventListener(MouseEvent.CLICK, onFlockClick);
			_content.unlockButton.addEventListener(MouseEvent.CLICK, onFlockClick);
			_content.timeText.text = (Global.getServerTime()).toString();
		//setInterval(getTimeText, 500);
			
			for (var i:int = 0; i < _quality.length; i++)
			{
				_quality[i] = new StateButton(_quality[i]);
				StateButton(_quality[i]).stateEvent.addListener(onQualityClick);
			}
			
			for (var locale:String in _locales)
			{
				_locales[locale] = new StateButton(_locales[locale]);
				StateButton(_locales[locale]).stateEvent.addListener(onLocaleClick);
			}
			
			refresh();
		}

		public function onColPick(evt:ColorPickerEvent):void
		{
			Global.charManager.uiColour = _content.uiColPick.selectedColor;
			Global.applyUIColour(_content.colourSprite);
			Global.frame.refresh();
		}
		
		public function onColDef(evt:MouseEvent):void
		{
			Global.charManager.defaultFrame = evt.currentTarget.selected;
			Global.frame.refresh();
		}
		public function checkLock():void
		{
			if(Global.lockMusic)
			_content.mLockButton.visible = false;
			else
			_content.mLockButton.visible = true;

			if(!Global.lockMusic)
			_content.unlockButton.visible = false;
			else
			_content.unlockButton.visible = true;
		}
		
		public function get content():McMenu
		{
			return _content;
		}
		public function getTimeText():void
		{
	//		_content.timeText.text = (Global.getServerTime()).toString();
		}
		
		public function onRequestClick(sender:StateButton):void
		{
			Global.acceptRequests = !Global.acceptRequests;
		}
		
		public function onLocationClick(sender:StateButton):void
		{
			Global.charManager.publicLocation = !Global.charManager.publicLocation;
		}

		public function onNightClick(sender:StateButton) : void
		{
			Global.acceptNight = !Global.acceptNight;
		}
		
		private function onSoundVolume(sender:Scroller):void
		{
			Global.soundVolume = sender.position * 100;
		}
		
		protected function onBrbClick(event:MouseEvent):void
		{
			Global.saveSettings();
			Global.charManager.body = "brb";
		}
		
		private function onMusicVolume(sender:Scroller):void
		{
			Global.musicVolume = sender.position * 100;
			Global.music.volume = sender.position;
		}
		
		private function onCharNames(sender:Object):void
		{
			Global.showCharNames = (_charNamesCheckBox.state == 2)
			if (Global.locationManager.location)
				Global.locationManager.location.refresh();
		}
		
		private function onQualityClick(sender:Object):void
		{
			var quality:int = _quality.indexOf(sender);
			Global.performanceManager.quality = quality;
			Global.localSettings.quality = quality;
			
			refresh();
		}
		
		private function onLocaleClick(sender:Object):void
		{
			Localiztion.locale = StateButton(sender).content.name;
			new CharService().setLocale(Localiztion.locale);
			refresh();
		}
		
		private function refresh():void
		{
			for (var i:int = 0; i < _quality.length; i++)
			{
				StateButton(_quality[i]).state = (Global.performanceManager.quality == i) ? 2 : 1;
			}
			
			for (var locale:String in _locales)
			{
				StateButton(_locales[locale]).state = (Localiztion.locale == locale) ? 2 : 1;
			}
		}
		
		private function onPasswordClick(e:MouseEvent):void
		{
			Dialogs.hideDialogWindow(_content);
			new ChangePasswordCommand().execute();
		}
		
		private function onLockClick(e:MouseEvent):void
		{
			Dialogs.hideDialogWindow(_content);
			Dialogs.showLongTextMessageDialog("123");
		}
		
		private function onCloseClick(e:Event):void
		{
			Global.saveSettings();
			Global.frame.refresh();
		}
		private function onFlockClick(e:Event):void
		{
			Global.lockMusic = !Global.lockMusic;
			checkLock();
		}


	
	}
}