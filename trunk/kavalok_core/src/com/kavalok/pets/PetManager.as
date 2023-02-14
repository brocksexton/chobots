package com.kavalok.pets
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.char.actions.PetAnimation;
	import com.kavalok.char.actions.PetMessage;
	import com.kavalok.dto.pet.PetTO;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.loaders.SafeURLLoader;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.messenger.commands.MessageBase;
	import com.kavalok.services.PetService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class PetManager
	{
		static public const IDLE_PERIOD:int = 45; //seconds
		static public const FOOD_PERIOD:int = 400; //seconds
		static public const FOOD_DEGRESSION:int = 1;
		static public const WARNING_VALUE:int = 10;
		
		private var _refreshEvent:EventSender = new EventSender();
		
		private var _isBusy:Boolean = false;
		private var _pet:PetTO;
		private var _foodTimer:Timer = new Timer(1000 * FOOD_PERIOD);
		private var _messages:Array;
		private var _loader:SafeURLLoader;
		
		public function initialzie(pet:PetTO):void
		{
			_foodTimer.addEventListener(TimerEvent.TIMER, onFood);
			this.pet = pet; 
			loadMessages();
		}
		
		private function loadMessages():void
		{
			var url:String = URLHelper.petMessagesURL();
			_loader = new SafeURLLoader();
			_loader.completeEvent.addListener(onMessagesLoaded);
			_loader.load(new URLRequest(url));
		}
		
		private function onMessagesLoaded():void
		{
			var xml:XML = new XML(_loader.data);
			_messages = [];
			
			for each (var message:String in xml.item)
			{
				_messages.push(message);
			}
		}
		
		public function set pet(value:PetTO):void
		{
			if (_pet == value)
				return;
				
			 Global.sendAchievement("ac9;","Pet");
			_pet = value;
			_isBusy = false;
			
			if (_pet)
				_foodTimer.start();
			else
				_foodTimer.stop();
			
			_refreshEvent.sendEvent();
		}
		
		public function set isBusy(value:Boolean):void
		{
			 if (value != _isBusy)
			 {
			 	_isBusy = value;
			 	_refreshEvent.sendEvent();
			 }
		}
		
		public function doIdleAction():void
		{
			if (_isBusy)
				return;
				
			if (Math.random() < 0.75 || _pet.loyality < 50)
			{
				var maxNum:int = PetModels.IDLE.length * _pet.loyality / 100.0;  
				var modelName:String = Arrays.randomItem(PetModels.IDLE.slice(0, maxNum + 1));
				sendAnimation(modelName);
			}
			else
			{
				//var maxMessageNum:int = _messages.length * _pet.loyality / 100.0;
				var maxMessageNum:int = _messages.length;
				maxMessageNum = Math.max(maxMessageNum, 10);
				sendMessage(Math.random() * maxMessageNum);
			}
		}
		
		public function doStuffAction(item:StuffItemLightTO):void
		{
			sendAnimation('Stuff_' + item.fileName);
			applyParameters(Strings.getParameters(item.info));
			update();
		}
		
		private function applyParameters(parameters:Object):void
		{
			for (var property:String in parameters)
			{
				var increment:int = parseInt(parameters[property]);
				var currentValue:int = _pet[property];
				
				_pet[property] = GraphUtils.claimRange(currentValue + increment, 0, 100);
			}
		}
		
		public function update():void
		{
			new PetService(onUpdate).saveParams(_pet.health, _pet.food, _pet.loyality, _pet.atHome, _pet.sit);
		}
		
		private function onUpdate(result:Object):void
		{
			if (_pet.food == 0 || _pet.health == 0)
				new PetService(onDispose).disposePet();
			else if (_pet.food < WARNING_VALUE || _pet.health < WARNING_VALUE)
				sendWarning();
			else
				_refreshEvent.sendEvent();
		}
		
		private function sendWarning():void
		{
			var message:MessageBase = new MessageBase();
			message.sender = _pet.name; 
			message.text = Global.resourceBundles.pets.messages.petIsHungry;
			Global.inbox.addMessage(message);
		}
		
		private function onDispose(result:Object):void
		{
			var message:MessageBase = new MessageBase();
			message.sender = _pet.name; 
			message.text = Global.resourceBundles.pets.messages.petDisposedText;
			Global.inbox.addMessage(message);
			pet = null;
		}
		
		private function onFood(e:TimerEvent):void
		{
			if (!_isBusy && _pet.loyality < 99)
			{
				_pet.food = Math.max(_pet.food - FOOD_DEGRESSION, 0);
				update();
			}
		}
		
		private function sendAnimation(modelName:String):void
		{
			_isBusy = true;
			Global.locationManager.location.sendUserAction(
				PetAnimation, {modelName: modelName});
		}
		
		private function sendMessage(messageNum:int):void
		{
			Global.locationManager.location.sendUserAction(
				PetMessage, {messageNum: messageNum});
		}
		
		public function isMy(pet:PetTO):Boolean
		{
			return (_pet && _pet.id == pet.id); 
		}
		
		public function getLoyalityGrade(loyality:int):int
		{
			return Math.ceil(loyality / 25);
		}
		
		public function get bundle():ResourceBundle
		{
			 return Global.resourceBundles.pets;
		}
		
		public function get isBusy():Boolean { return _isBusy; }
		public function get pet():PetTO { return _pet; }
		public function get isSitting():Boolean { if(pet) return pet.sit; else return false; }
		public function get messages():Array { return _messages; }
		
		public function get refreshEvent():EventSender { return _refreshEvent; }
	}
}