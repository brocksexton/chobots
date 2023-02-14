package com.kavalok.location.entryPoints
{
	import com.junkbyte.console.Cc;
	import com.kavalok.Global;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.Directions;
	import com.kavalok.char.LocationChar;
	import com.kavalok.char.Stuffs;
	import com.kavalok.char.actions.CharActionBase;
	import com.kavalok.char.modifiers.BoardModifier;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dialogs.DialogOk;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.chat.BubbleStyles;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.commands.RetriveStuffCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.gameplay.frame.GameFrameView;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.gameplay.notifications.Notifications;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.fish.FishType;
	import com.kavalok.serialization.Serializer;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.MathUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.security.Base64;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	
	public class FishingEntryPoint extends EntryPointBase
	{
		public static const BASIC_ROD_NAME:String = "fishingPoleDefault";
		public static const CITIZEN_ROD_NAME:String = "fishingPoleCitizen";
		//public static const PREMIUM_ROD_NAME:String = "premium_fishing_rod";
		
		//private var isFishing:Boolean = false;
		private var fishTimer:Timer;
		private var initMCs:Array = [];
		private var _time:Date;
		private var _holes : Array = [];
		private static const HOLE_NAME_PREFIX : String = "hole_";
		private static const HOLE_NAME : String = "hole";
		private var _currentHole : MovieClip;
		
		public static var fishies:Array = [];
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		public function FishingEntryPoint(location:LocationBase, prefix:String=null, remoteId:String=null)
		{
			_location = location;
			Global.charManager.charViewChangeEvent.addListenerIfHasNot(onCharChangedEvent);
			
			Global.locationManager.locationChange.addListenerIfHasNot(onLocationChange);
			_time = Global.getServerTime();
			
			registerHoles(_location.content);
			if(location.locId == "locBeach") {
				new StuffServiceNT(onGotStuffTypes, onFailGetStuffTypes).getStuffTypes("fish");
			}
			super(location, "fishing", remoteId);
			_location.readyEvent.addListener(initMousePointer);
		}
		
		private function registerHoles(container : Sprite) : void
		{
			for(var i : uint = 0; i < container.numChildren; i++)
			{
				var child : DisplayObject = container.getChildAt(i);
				if(child is MovieClip && (Strings.startsWidth(child.name, HOLE_NAME_PREFIX) || child.name == HOLE_NAME))
				{
					_holes.push(child);
					MovieClip(child).activePool.gotoAndStop(1);
				}
			}
		}
		
		private function onLocationChange():void
		{
			if(Global.isFishing)
				endFish();
		}
		
		private function onCharChangedEvent(e:* = null):void
		{
			initMousePointer();
		}
		
		override public function initialize(mc:MovieClip):void
		{
			initMCs.push(mc);
			initMousePointer();
			mc.alpha = 0;
			
			super.initialize(mc);
		}
		
		private function onGotStuffTypes(stuffsarray:Array):void
		{
			fishies.push({ name: BASIC_ROD_NAME, fish: new FishType(0, "null", 10, BASIC_ROD_NAME, "Null", false) });// null/void/no item, no reward
			fishies.push({ name: BASIC_ROD_NAME, fish: new FishType(1, "bugs", 10, BASIC_ROD_NAME, "#{amount} bugs", false) }); // bugs
			for each(var item:StuffTypeTO in stuffsarray)
			{
				if(item.type == StuffTypes.FISH) {
					var id:int = fishies.length+1;
					var rodName:String = (item.otherInfo.split("r=")[1].split(";")[0] == 1) ? BASIC_ROD_NAME : (item.otherInfo.split("r=")[1].split(";")[0] == 2) ? CITIZEN_ROD_NAME : "0";
					var probability:int = item.otherInfo.split("p=")[1].split(";")[0];
					var isItem:Boolean = item.otherInfo.split("it=")[1].split(";")[0];
					var dayNightTimes:int = item.otherInfo.split("dn=")[1].split(";")[0]; // 1 = day only, 2= night only, 3 or otherwise = anytime
					// 11pm -> 8am
					if(dayNightTimes == 2 && _time.hours < 23 && _time.hours > 8 )
					{
						return; //Cc.log("night time only fish " + item.name);
					} else if(dayNightTimes == 1 && _time.hours > 23 && _time.hours < 8) {
						return; //Cc.log("day only fish");
					}
					fishies.push({ name: rodName, fish: new FishType(id, item.fileName, probability, rodName, item.name, isItem) });
				}
			}
			initMousePointer();
		}

		private function onFailGetStuffTypes(e:* = null):void
		{
			Cc.log("error getting stuff types");
		}
		
		private function initMousePointer():void
		{
			if(isWearingRod()){
				for each(var i:DisplayObject in initMCs) {
					MousePointer.registerObject(i, MousePointer.ACTION);
				}
			} else {
				removeMousePointer();
			}
		}
		
		private function removeMousePointer():void 
		{
			for each(var i:DisplayObject in initMCs) {
				MousePointer.unRegisterObject(i);
			}
			MousePointer.resetIcon();
		}
		
		private function isWearingRod():Boolean 
		{
			if(stuffs.isItemUsed(BASIC_ROD_NAME) || stuffs.isItemUsed(CITIZEN_ROD_NAME)) {
				return true;
			}
			return false;
		}
		
		override public function get charPosition():Point 
		{
			var point:Point = new Point(clickedClip.x, clickedClip.y);
			//GraphUtils.transformCoords(point, clickedClip, clickedClip.parent);
			return point;
		}
		
		private function doFish():void 
		{
			Global.isFishing = true;
			removeMousePointer();
			showFishingAnimations();
			
			fishTimer = new Timer(100, 0);
			fishTimer.addEventListener(TimerEvent.TIMER, onFishFirstTimer);
			fishTimer.start();
		}
		
		private function showFishingAnimations():void
		{
			/*var char:LocationChar = _location.chars[Global.charManager.charId];
			if	(char != null)
				char.setModel(CharModels.THROW, Directions.getDirection(lastMouseX - char.content.x, lastMouseY - char.content.y))
			*/
			 var idx:int=Math.floor(Math.random() * _holes.length);
			 _currentHole = _holes[idx];
			 _currentHole.activePool.gotoAndPlay(2);
		}
		
		protected function onFishFirstTimer(event:TimerEvent = null):void
		{
			fishTimer.stop();
			var time:int = MathUtils.randomNumberRange(5, 10);
			Cc.log("waiting -> " + time + " secs");
			
			var char:LocationChar = _location.chars[Global.charManager.charId];
			if	(char != null)
				char.setModel(CharModels.THROW, Directions.getDirection(lastMouseX - char.content.x, lastMouseY - char.content.y))
				
			fishTimer = new Timer(time * 1000, 0);
			fishTimer.addEventListener(TimerEvent.TIMER, onFishTimer);
			fishTimer.start();
		}
		
		protected function onFishTimer(event:TimerEvent = null):void
		{
			if(Global.isFishing)
			{
				var weights:Array = [];
				for each(var fish:FishType in getFishiesByRod()){
					weights.push(fish.probability);
				}
				processFish(MathUtils.randomIndexByWeights(weights));
			}
		}
		
		private function processFish(prob:int):void 
		{
			_currentHole.activePool.gotoAndStop(1);
			_currentHole.Splash.gotoAndPlay(2);
			var fishs:Array = getFishiesByRod();
			var le_fish:FishType = fishs[prob];
			if(le_fish == null) {
				endFish();
				return;
			}
			var selc_fish:FishType = le_fish;
			//Cc.log(selc_fish.name);
			
			// award fish 
			if(le_fish.name == "null")
			{
				//Dialogs.showOkDialog("The fish swam away, darn it!", true);
				endFish();
				return;
			}
			
		    if(!le_fish.isItem)
			{
				processBugs(le_fish);
				endFish();
				return;
			} else {
				if(canGetMoreFish()) {
					Global.frame.showNotification("Yay You've caught a " + le_fish.nice_name, "fishing", le_fish.name); // Global.frame.showNotification(notify,"achievements");
					new RetriveStuffCommand(le_fish.name, "").execute();
				} else {
					Dialogs.showOkDialog("Your fishermans backpack is full!", true)
					endFish();
					return;
				}
			}
			
			//doIHaveFish(le_fish.name);
			endFish();
			//Dialogs.showOkDialog(msg, true);
			
			if(le_fish.probability < 21 )
				Global.addExperience(1);
		}
		
		private function canGetMoreFish():Boolean
		{
			var maxFish:int = (Global.charManager.isCitizen) ? 10 : 5;
			if(Global.charManager.isModerator){
				maxFish = 99999;
			}
			return !(stuffs.getStuffsCount(StuffTypes.FISH) >= maxFish);
		}
		
		public function doIHaveFish(fishName:String):void
		{
			var haveFish:Boolean = stuffs.stuffExists(fishName);
			if(haveFish) {
				Cc.log("I already have this fish!");
			} else {
				Cc.log("New fish caught!");
			}
		}
		
		private function processBugs(le_fish:FishType):void
		{
			var bugs:int = getRandomBugs();
			if(!le_fish.isItem && le_fish.name == "bugs")
			{
				Cc.log("giving bugs");
				new AddMoneyCommand(bugs, Competitions.COINS, false, null, false).execute();
				Dialogs.showOkDialog("Yay! You've found " + bugs + " bugs in the bottom of the ocean", true);
			}
		}
		
		private function getRandomBugs():int
		{
			var bugs:Array = [
					20, 50, 100	
				];
			var bugsProb:Array = [
					50, 30, 20
				];
			return bugs[MathUtils.randomIndexByWeights(bugsProb)];
		}
		
		private function getFishiesByRod():Array
		{
			var rods:Array = [BASIC_ROD_NAME];
			if(stuffs.isItemUsed(CITIZEN_ROD_NAME)) {
				rods.push(CITIZEN_ROD_NAME);
			}
			var fis:Array = [];
			for each(var rod:String in rods){
				for each(var o:Object in fishies) {
					if(o.name == rod)
					{
						//Cc.log("getFishiesByRod: " + o.name + " - " + o.fish.name);
						fis.push(o.fish);
					}
				}
			}
			return fis;
		}
		
		private function endFish():void 
		{
			if(!Global.isFishing)
				return;
				
			_currentHole.activePool.gotoAndStop(1);
				
			initMousePointer();
			Global.isFishing = false;
			if(fishTimer != null)
				fishTimer.stop();
		}
		
		override public function destroy():void
		{
			Global.charManager.charViewChangeEvent.removeListenerIfHas(onCharChangedEvent);
			super.destroy();
		}
		
		override public function goIn():void
		{
			if(!Global.isFishing)
				doFish();
			super.goIn();
		}
		
		override public function goOut():void
		{
			if(Global.isFishing) 
				endFish();
			
			super.goOut();
		}
		
		override protected function onClick(event : MouseEvent) : void
		{
			var mc:MovieClip = MovieClip(event['currentTarget']);
			if (mc.hitTestPoint(
				Global.stage.mouseX,
				Global.stage.mouseY) && isWearingRod())
			{
				if(Global.isFishing) 
					return;
				//doFish();
				clickedClip = mc;
				lastMouseX = Global.stage.mouseX;
				lastMouseY = Global.stage.mouseY;
				activateEvent.sendEvent(this);
			} else {
				if(Global.isFishing){
					endFish();
				}
			}
		}
		
		private function get stuffs():Stuffs 
		{
			return Global.charManager.stuffs;
		}
	}
}