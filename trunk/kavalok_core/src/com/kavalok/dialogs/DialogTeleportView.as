package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.modules.ModuleManager;
	import com.kavalok.constants.Modules;
	import com.kavalok.char.modifiers.CharModifierBase;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharManager;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import com.kavalok.location.LocationBase;
	
	import com.kavalok.events.EventSender;
	
	public class DialogTeleportView extends DialogViewBase
	{
		
		public var yesButton:SimpleButton;
		public var noButton:SimpleButton;
		public var cafeButton:SimpleButton;
		public var shopButton:SimpleButton;
		public var ropeButton:SimpleButton;
		public var academyButton:SimpleButton;
		public var graphityButton:SimpleButton;
		public var musicButton:SimpleButton;
		public var parkButton:SimpleButton;
		private var _yes:EventSender = new EventSender();
		private var _no:EventSender = new EventSender();
		
		public function DialogTeleportView(text:String, modal:Boolean = true)
		{
			super(new DialogTeleport(), text, modal);
			Global.resourceBundles.kavalok.registerButton(yesButton, "locAgents")
			Global.resourceBundles.kavalok.registerButton(noButton, "close")
			Global.resourceBundles.kavalok.registerButton(shopButton, "locAccShop")
			Global.resourceBundles.kavalok.registerButton(ropeButton, "locCitizen")
			Global.resourceBundles.kavalok.registerButton(academyButton, "locAcademy")
			Global.resourceBundles.kavalok.registerButton(graphityButton, "locGraphityA")
			Global.resourceBundles.kavalok.registerButton(musicButton, "locMusic")
			Global.resourceBundles.kavalok.registerButton(parkButton, "locPark")
			Global.resourceBundles.kavalok.registerButton(cafeButton, "loc3")
			yesButton.addEventListener(MouseEvent.CLICK, onYesClick);
			noButton.addEventListener(MouseEvent.CLICK, onNoClick);
			cafeButton.addEventListener(MouseEvent.CLICK, onCafeClick);
			parkButton.addEventListener(MouseEvent.CLICK, onParkClick);
			academyButton.addEventListener(MouseEvent.CLICK, onAcademyClick);
			ropeButton.addEventListener(MouseEvent.CLICK, onCitizenClick);
			graphityButton.addEventListener(MouseEvent.CLICK, onGraphityClick);
			musicButton.addEventListener(MouseEvent.CLICK, onMusicClick);
			shopButton.addEventListener(MouseEvent.CLICK, onShopClick);
		}
		
		public function get yes():EventSender
		{
			return _yes;
		}
		
		public function get no():EventSender
		{
			return _no;
		}
		
		private function onYesClick(event:MouseEvent):void
		{
			hide();
			Global.moduleManager.loadModule(Modules.AGENTS);
		}
		
		private function onCafeClick(event:MouseEvent):void
		{
			hide();
			Global.moduleManager.loadModule(Modules.CAFE);
		}
		
		private function onParkClick(event:MouseEvent):void
		{
			hide();
			Global.moduleManager.loadModule(Modules.PARK);
		}
		
		private function onMusicClick(event:MouseEvent):void
		{
			hide();
			Global.moduleManager.loadModule(Modules.MUSIC);
		}
		
		private function onGraphityClick(event:MouseEvent):void
		{
			hide();
			Global.moduleManager.loadModule(Modules.GRAPHITY);
		}
		
		private function onAcademyClick(event:MouseEvent):void
		{
			hide();
			Global.moduleManager.loadModule(Modules.ACADEMYS);
		}
		
		private function onCitizenClick(event:MouseEvent):void
		{
			hide();
			Global.moduleManager.loadModule(Modules.CITIZEN);
		}
		
		private function onShopClick(event:MouseEvent):void
		{
			hide();
			Global.moduleManager.loadModule(Modules.SHOP);
		}
		
		private function onNoClick(event:MouseEvent):void
		{
			hide();
			no.sendEvent();
		}
	}
}