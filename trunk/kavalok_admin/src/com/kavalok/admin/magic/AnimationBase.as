package com.kavalok.admin.magic
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.location.commands.FlyingPromoCommand;
	import com.kavalok.location.commands.PlayMP3Command;
	import com.kavalok.location.commands.PlaySwfCommand;
	import com.kavalok.location.commands.NotificationCommand;
	import com.kavalok.location.commands.PromoCommand;
	import com.kavalok.location.commands.ResetVolumeCommand;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LocationInfoService;
	import com.kavalok.services.LogService;
	import com.kavalok.utils.Strings;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import mx.controls.ComboBox;
	import mx.controls.HSlider;
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.controls.CheckBox;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.utils.Arrays;
	

	public class AnimationBase extends MagicViewBase
	{
		static public const URL_PREFIX:String = './resources/magic/';
		static public const EMPTY_STRING:String = '';
		public var loader:Loader = new Loader();
		
		[Bindable] public var urlField:TextInput;
		[Bindable] public var urlCombo:List;
		[Bindable] public var musicInput:TextInput;
		[Bindable] public var selectedPromo : String;
		[Bindable] public var promoComboBox:ComboBox;
		[Bindable] public var volumeSlider:HSlider;
		[Bindable] public var promoData:ArrayList;
		[Bindable] public var uicomp:UIComponent;
		[Bindable] public var notifyField:TextInput;

		[Bindable] public var animationURL:String;
		[Bindable] public var notifyText:String;

		[Bindable] public var promoInput:TextInput;
		[Bindable] public var animationList:ArrayList;

		[Bindable] public var globalCheckBox:CheckBox;
		//[Bindable] public var globally:Boolean = false;
		
		public function AnimationBase()
		{
			super();
			Security.allowDomain('*');
			loadList();
			var pList:ArrayList = new ArrayList();
			pList.addItem({label: "original", id: "original", name: "original", item: "original"});
			pList.addItem({label: "slenderman", id: "slenderman", name: "slenderman", item: "slenderman"});
			//pList.addItem({label: "blackandwhite", id:"blackandwhite", name:"blackandwhite", item:"blackandwhite"});
			//pList.addItem({label: "yolo", id:"yolo", name:"yolo", item:"yolo"});
			promoData = pList;
		}
		
		private function loadList():void
		{
			var url:String = URL_PREFIX + 'magic.xml';
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest(url));
		}
		
		private function onLoadComplete(e:Event):void 
		{
			var list:ArrayList = new ArrayList();
			var xml:XML = new XML(URLLoader(e.target).data);
			for each (var item:String in xml.item) 
			{
				list.addItem(item);
			}
			animationList = list;
		}

		
		protected function refreshByCombo():void 
		{
			animationURL = URL_PREFIX + urlCombo.selectedItem;
			urlField.text = animationURL;
		//	var request:URLRequest = new URLRequest(animationURL);
			//loader.load(request);
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLLoadComplete);
			
			
		}
		private function onLLoadComplete(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			var movie:MovieClip = LoaderInfo(e.target).content as MovieClip;
			uicomp.addChild(loader);
			loader.content.width=200;
			loader.content.height=140;
			movie.addEventListener(Event.ENTER_FRAME, onMovieFrame);

		}
		
		private function onMovieFrame(e:Event):void
		{
			var movie:MovieClip = e.target as MovieClip;
			if (movie.currentFrame == movie.totalFrames)
			{
			
				movie.removeEventListener(Event.ENTER_FRAME, onMovieFrame);
				loader.unload();
			}
		}
		
		protected function updateChange():void
		{
		   selectedPromo = EMPTY_STRING + promoComboBox.selectedItem.label;
		}
		
		
		protected function refreshByInput():void 
		{
			animationURL = Strings.trim(urlField.text);
			urlCombo.selectedItem = null;
		}

		protected function refreshByInputN():void
		{
			notifyText = Strings.trim(notifyField.text);

		}
		
		public function onSendClick():void
		{
			
			
			var command:PlaySwfCommand = new PlaySwfCommand();
			command.url = animationURL;
			command.hash = currentRoomHash;
			sendLocationCommand(command);
			new LogService().adminLog("Sent animation " + urlCombo.selectedItem + " to " + remoteId, 1, "magic");
			
		}

		public function onSendNotification():void
		{
			if(globalCheckBox.selected){
				new AdminService().sendNotification(Strings.trim(notifyField.text));
				new LogService().adminLog("Sent notification: " + text + ":: to all", 1, "magic");
			} else {
			var text:String = Strings.trim(notifyField.text);
			var command:NotificationCommand = new NotificationCommand();
			command.notify = text;
			sendLocationCommand(command);
			new LogService().adminLog("Sent notification: " + text + ":: to " + remoteId, 1, "magic");
		}
			
		}
		
		public function get promoType():String
		{
			return String(promoComboBox.selectedItem.label);
		}

		
		public function sendPromo():void
		{
		   var text:String = Strings.trim(promoInput.text);
		   var command:PromoCommand = new PromoCommand();
		   command.Ptype = promoType;
		   command.text = text;
		   sendLocationCommand(command);
		   new LogService().adminLog("Sent promo saying:'" + text + "' at " + remoteId, 1, "magic");
		}
		
		
			public function playMusicMP3():void
		{
			var url:String = Strings.trim(musicInput.text);

			if (!Strings.isBlank(url))
			{
				var command:PlayMP3Command = new PlayMP3Command();
				command.url = url;
				sendLocationCommand(command);
				new LogService().adminLog("Played MP3 url " + url + " at " + remoteId, 1, "magic");
			}
		}

		public function stopMusicMP3():void
		{
			var command:PlayMP3Command = new PlayMP3Command();
			command.url = "http://google.comf"
			sendLocationCommand(command);
		}

		public function resetMusicVolume():void
		{
				var command:ResetVolumeCommand = new ResetVolumeCommand();
				command.url = volumeSlider.value;
				sendLocationCommand(command);


			
		}

		
	}
	
}