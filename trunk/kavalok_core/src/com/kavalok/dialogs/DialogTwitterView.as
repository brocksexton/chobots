package com.kavalok.dialogs
{
	
	import com.kavalok.Global;
	import com.kavalok.McCharWindow;
	import com.kavalok.MoodType;
	import com.kavalok.RankType;
	import com.kavalok.char.Char;
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
	
	public class DialogTwitterView extends DialogViewBase
	{
		/*public var okButton:SimpleButton;
		public var TwitterConnect:SimpleButton;
		public var LoadTimeline:SimpleButton;
		public var Input:TextField;
		public var SendTweet:SimpleButton;
		public var welcomeMsg:TextField;
		public var inputBg:Sprite;
		public var myLoader2:Sprite;
		public var myLoader:Loader = new Loader();
		private var _bundle:ResourceBundle = Global.resourceBundles.kavalok;
		private var _yes:EventSender = new EventSender();
		private var _no:EventSender = new EventSender();*/
		
		public var twitTitle:TextField;
		public var exitButton:SimpleButton;
		public var connectToTwitter:SimpleButton;
		public var welcomeInfo:TextField;
		public var sendTweet:SimpleButton;
		public var openTimeline:SimpleButton;
		public var imgLoad:Sprite;
		public var _bundle:ResourceBundle = Global.resourceBundles.kavalok;
		private var _yes:EventSender = new EventSender();
		private var _no:EventSender = new EventSender();
		public var myLoader:Loader = new Loader();
		
		public function DialogTwitterView(text:String = null, modal:Boolean = true)
		{
			super(new DialogTwitter() as MovieClip, text, modal);
			Security.allowDomain("*");
			//new AdminService(onGetURL).getProfilePicture(Global.charManager.twitterName);
			exitButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			sendTweet.addEventListener(MouseEvent.CLICK, onSendTweet);
			connectToTwitter.addEventListener(MouseEvent.CLICK, onTwitterClick);
			openTimeline.addEventListener(MouseEvent.CLICK, onLoadTimeline);
			twitTitle.text = "Twitter";
			welcomeInfo.text = Strings.substitute(Global.charManager.twitterName + ", what would you like to do?");
			
			/*Input.visible = false;
			SendTweet.visible = false;
			TwitterConnect.visible = false;
			welcomeMsg.visible = false;
			inputBg.visible = false;
			LoadTimeline.visible = false;*/
			
			if(Global.charManager.accessToken == "notoken"){
				sendTweet.visible = false;
				connectToTwitter.visible = true;
				imgLoad.visible = false;
				welcomeInfo.visible = false;
				openTimeline.visible = false;
				
			} else {
				
				sendTweet.visible = true;
				imgLoad.visible = true;
				connectToTwitter.visible = false;
				welcomeInfo.visible = true;
				openTimeline.visible = true;
				new AdminService(onGetURL).getProfilePicture(Global.charManager.accessToken, Global.charManager.accessTokenSecret);
				
			}
		}
		
		public function get yes():EventSender
		{
			return _yes;
		}
		
		public function get no():EventSender
		{
			return _no;
		}
		
		private function onCloseClick(event:MouseEvent):void
		{
			hide();
			yes.sendEvent();
		}
		
		private function onTwitterClick(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://kavalok.net/twitter/"), "_blank");
		}
		
		private function onLoadTimeline(event:MouseEvent):void
		{
			Global.isLocked = true;
			new AdminService().loadTimeline(Global.charManager.userId, Global.charManager.accessToken, Global.charManager.accessTokenSecret);
			hide();
			yes.sendEvent();
		}
		
		private function onSendTweet(event:MouseEvent):void
		{
			hide();
			Dialogs.showSendTweetDialog("");
			yes.sendEvent();
		}
		
		private function onGetURL(url:String):void
		{
			myLoader.load(new URLRequest(url));
			imgLoad.addChild(myLoader);
		}
		
	}
}