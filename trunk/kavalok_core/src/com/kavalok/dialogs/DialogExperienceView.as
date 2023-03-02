package com.kavalok.dialogs
{
	import com.kavalok.Global;
	
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import com.kavalok.services.CharService;
	import flash.net.URLLoader;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.controls.ProgressBar;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
    import com.kavalok.constants.ResourceBundles;
	import com.kavalok.level.Levels;
	import com.kavalok.level.LevelItem;
	import com.kavalok.level.LevelTitle;
	import flash.display.Sprite;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.localization.Localiztion;
	import flash.net.navigateToURL;
	import com.kavalok.utils.Strings;
	import com.kavalok.dto.stuff.StuffTypeTO;
	
	import com.kavalok.events.EventSender;

	public class DialogExperienceView extends DialogViewBase
	{
		public var okButton : SimpleButton;
		public var helpButton : SimpleButton;
		public var choField : TextField;
		public var lvlField : TextField;
		public var twitButton : SimpleButton;
		public var nextField : TextField;
		public var titleField : TextField;
		private var namess:Array = ["Xecho", "Nichorex", "Yocho", "Dicho", "Choxo", "Qexocho", "Chogex", "Texcho", "Gergox", "Skelecho", "Jake", "Brock"];
		public var expBar : Sprite;
		public var progressBar : Sprite;
		public var _stuff : ResourceSprite;
		public var lolSprite : Sprite;

		private var _yes : EventSender = new EventSender();
		private var _no : EventSender = new EventSender();
		private var _bundle:ResourceBundle = Global.resourceBundles.kavalok;
		private var myExp:String = Global.charManager.experience.toString();
		private var myLevel:String = Global.charManager.charLevel.toString()
		private var myNext:String = (Global.totalExp - Global.charManager.experience).toString();
		private var fileName:String = LevelItem.fileName;
		private var itemId:int = LevelItem.itemId;
		private var stuffType:String = LevelItem.itemType;
		private var _progBar:ProgressBar;
		

		public function DialogExperienceView(text:String, modal : Boolean = true)
		{
			var levelTitles:LevelTitle = new LevelTitle();
			super(new DialogExperience(), text, modal);
		    okButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		    helpButton.addEventListener(MouseEvent.CLICK, onHelpClick);
			choField.text = Strings.substitute(myExp);
			lvlField.text = Strings.substitute(myLevel);
			nextField.text = Strings.substitute(myNext);
			titleField.text = Strings.substitute(Localiztion.getBundle("titles").messages["level" + Global.charManager.charLevel]);
			twitButton.visible = (Global.charManager.accessToken != "notoken");
			ToolTips.registerObject(twitButton, 'Share this on Twitter', ResourceBundles.KAVALOK);
			twitButton.addEventListener(MouseEvent.CLICK, onTwitterClick);
			_progBar = new ProgressBar(expBar);
			 var theLevel:Levels = new Levels();
			_progBar.value = Number(((Global.charManager.experience - theLevel.prevLevel()) / (theLevel.formula() - theLevel.prevLevel())));
			trace(_progBar.value);
			var info:StuffTypeTO = new StuffTypeTO();
			info.fileName = LevelItem.fileName;
			info.id = LevelItem.itemId;
			info.type = stuffType;
			_stuff = info.createModel();
			_stuff.loadContent();
			_stuff.y = 153.25;
			_stuff.x = 316.20;
			lolSprite.addChild(_stuff);
			
		
		}
		
		public function get yes() : EventSender
		{
			return _yes;
		}
		public function get no() : EventSender
		{
			return _no;
		}
		
		private function onCloseClick(event : MouseEvent) : void
		{
			hide();
			yes.sendEvent();
		}
		private function onTwitterClick(event : MouseEvent) : void
		{
			var p:int = Global.charManager.experience;
			if(p < 500)
			Global.newTweet("Coolio, right now I have " + p + " Cho Energy on @Chobots!");
			else if (p < 1000)
			Global.newTweet("Guess how many cho energy I have on @Chobots? " + p);
			else if (p < 1250)
			Global.newTweet("I have " + p + " cho energy on @Chobots. Almost enough to beat " + namess.sort(sortRand) + ";-)");
			else if (p < 1500)
			Global.newTweet("Yummy. I'm pro at collecting Cho energy on @Chobots - I have " + p + "!");
			else if (p < 2000)
			Global.newTweet("Cowabunga! I have " + p + " cho energy on @Chobots. I bet you're jealous...");
			else if (p < 5000)
			Global.newTweet("Delicious: " + p + " cho energy in my posession on @Chobots. Be afraid! >:)");
			else if (p < 8000)
			Global.newTweet("Mwahahaha, " + p + " cho energy is all mine on @Chobots!");
			else if (p < 12000)
			Global.newTweet("Nichos do not want to mess with me and my " + p + " cho energy on @Chobots");
			else if (p > 12000)
			Global.newTweet("Take a bow, young Chobots, for I am the master of Cho Energy. Seriously - I have " + p + " cho!");
			else 
			Global.newTweet("Sweet, I have " + p + " cho energy on @Chobots");
		}
		
		private function sortRand(a:*, b:*):Number
		{
		    if (Math.random() < 0.5) return -1;
		    else return 1;
		}

	
		

        private function onHelpClick(event : MouseEvent) : void
        {
        	navigateToURL(new URLRequest("http://www.chobots.wiki/wiki/cho-help.html"), "_blank");
        }

	}
}