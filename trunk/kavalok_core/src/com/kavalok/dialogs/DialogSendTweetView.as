package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.McCharWindow;
	import com.kavalok.MoodType;
	import com.kavalok.RankType;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharManager;
	import com.kavalok.char.CharModel;
	import com.kavalok.dialogs.DialogSendTweetView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.controls.RectangleSprite;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.location.LocationManager;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.CharService;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.ui.Window;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.NameRequirement;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.utils.Strings;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;

	public class DialogSendTweetView extends DialogViewBase
	{
		public var yesButton : SimpleButton;
		public var noButton : SimpleButton;
		public var charsLeft:TextField;
		public var twatName:TextField;
		public var twitterText : TextField;
        public var _tweetMsg : String;
		private var _yes : EventSender = new EventSender();
		private var _no : EventSender = new EventSender();
		
		private var alreadyInputValue:Boolean;
		
		private var oldLength:Number = 0;

		public function DialogSendTweetView(tweetMsg:String, text:String = null, modal : Boolean = true)
		{
			super(new DialogSendTweet(), text, modal);
			twitterText.addEventListener(MouseEvent.CLICK, onTextClick);
			Global.resourceBundles.kavalok.registerButton(yesButton, "tweet")
			Global.resourceBundles.kavalok.registerButton(noButton, "nope")
			yesButton.addEventListener(MouseEvent.CLICK, onYesClick);
			noButton.addEventListener(MouseEvent.CLICK, onNoClick);
			twatName.text = "Tweeting as @" + Global.upperCase(Global.charManager.twitterName);
			charsLeft.text = "Characters left: 140";
			
			twitterText.maxChars = 140;
			twitterText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			charsLeft.text = "Characters left: " + (140 - twitterText.length);
		}
		
		public function get yes() : EventSender
		{
			return _yes;
		}
		public function get no() : EventSender
		{
			return _no;
		}
		
		private function onTextClick(event : MouseEvent) : void
		{
			if (alreadyInputValue)
				return;
			
			twitterText.text = "";
			alreadyInputValue = true;
		}
		
		private function onYesClick(event : MouseEvent) : void
		{
			hide();
			yes.sendEvent();
			Global.newTweet(twitterText.text);
		}
		
		private function onFailTweet(err:String = "fail_service_call_error"):void
		{
			trace(err);
		}
		
		private function onSentTweet(e:String = "no_error"):void
		{
			trace(e);
		}
		
		private function get charManager():CharManager {
			return Global.charManager;
		}

		private function onNoClick(event : MouseEvent) : void
		{
			twitterText.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			hide();
			no.sendEvent();
		}
	}
}