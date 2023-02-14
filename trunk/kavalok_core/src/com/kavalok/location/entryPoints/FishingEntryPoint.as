package com.kavalok.location.entryPoints
{
	
	import ChoData.FishInfo;
	
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
		public static const BASIC_ROD_NAME:String = "fishing";
		//public static const CITIZEN_ROD_NAME:String = "citizen_fishing_rod";
		//public static const PREMIUM_ROD_NAME:String = "premium_fishing_rod";
		
		//private var isFishing:Boolean = false;
		private var fishTimer:Timer;
		private var initMCs:Array = [];
		private var _time:Date;
		
		public static var fishies:Array = [ 
			// we can load the fishies from the db in the future, but for now.. lets just make it static
			
			
			/*
			{ name: CITIZEN_ROD_NAME, fish: new FishType(1, "null", 15, CITIZEN_ROD_NAME, "Null") },
			{ name: CITIZEN_ROD_NAME, fish: new FishType(1, "basic_fish", 50, CITIZEN_ROD_NAME, "Basic Fish") },
			{ name: CITIZEN_ROD_NAME, fish: new FishType(1, "uncommon_fish", 25, CITIZEN_ROD_NAME, "Uncommon Fish") },
			{ name: CITIZEN_ROD_NAME, fish: new FishType(1, "rare_fish", 10, CITIZEN_ROD_NAME, "Rare Fish") },
			{ name: CITIZEN_ROD_NAME, fish: new FishType(1, "nicho_fish", 5, CITIZEN_ROD_NAME, "Nicho Fish") },
			*/
			
		];
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		public function FishingEntryPoint(location:LocationBase, prefix:String=null, remoteId:String=null)
		{
			//TODO: implement function
			_location = location;
			Global.charManager.charViewChangeEvent.addListenerIfHasNot(onCharChangedEvent);
			
			Global.locationManager.locationChange.addListenerIfHasNot(onLocationChange);
			_time = Global.getServerTime();
			
			
			super(location, "fishing", remoteId);
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
			trace("initalizing fishing entry point... " + mc.name);
			
			
			new StuffServiceNT(onGotStuffTypes, onFailGetStuffTypes).getStuffTypes("fish");
			
			initMCs.push(mc);
			
			//initMousePointer(); // gears
			mc.alpha = 0;
			
			super.initialize(mc);
		}
		
		private function onGotStuffTypes(stuffsarray:Array):void
		{
			fishies.push({ name: BASIC_ROD_NAME, fish: new FishType(0, "null", 20, BASIC_ROD_NAME, "Null", false) });
			// ^ null/void/no item, no reward
			
			// bugs
			fishies.push({ name: BASIC_ROD_NAME, fish: new FishType(1, "bugs", 10, BASIC_ROD_NAME, "#{amount} bugs", false) });
			
			var totalBytes:int = 0;
			
			for each(var item:StuffTypeTO in stuffsarray)
			{
				processFishInfoType(item);
				totalBytes = totalBytes + (item.otherInfo as Array).length;
			}
			
			trace("Total Bytes Received: " + totalBytes + " bytes");
			
			initMousePointer();
		}
		
		private function processFishInfoType(item:StuffTypeTO):void 
		{
			var fishInfo:FishInfo = getFishOtherInfo(item.otherInfo);
			//	trace("decode -> " + fishInfo.id + " <- rod -> " + fishInfo.r);
			
			trace("FishInfo Payload: " + fishInfo.toString() + " Payload Size: " + (item.otherInfo as Array).length 
				+ " bytes");
			var id:int = fishInfo.id;
			var rodName:String = (fishInfo.r == 1) ? BASIC_ROD_NAME : "0";
			var probability:int = fishInfo.p;
			var isItem:Boolean = fishInfo.it;
			var dayNightTimes:int = fishInfo.dn; // 1 = day only, 2= night only, 3 or otherwise = anytime
			
			// 11pm -> 8am
			if(dayNightTimes == 2 && _time.hours < 23 && _time.hours > 8 )
			{
				trace("night time only fish " + item.name);
				return;
				
			} else if(dayNightTimes == 1 && _time.hours > 23 && _time.hours < 8) {
				trace("day only fish");
				return;
			}
			fishies.push({ name: rodName, fish: new FishType(id, item.fileName, probability, rodName, item.name, isItem) });
			
		}
		
		private function getFishOtherInfo(otherInfo:*):FishInfo
		{
			var byteArray:ByteArray = new ByteArray();
			for each(var o:int in otherInfo)
			{
				byteArray.writeByte(o);
			}
			var b64d:String = Serializer.toBase64(byteArray);
			
			var fi:FishInfo = new FishInfo();
			fi.mergeFrom(Serializer.fromBase64(b64d));
			//trace(b64d);
			//trace("info :> " + fi.p); 
			
			
			return fi;
			//return BSON.decode(Serializer.fromBase64(b64d));
			
		}
		
		private function onFailGetStuffTypes(e:* = null):void
		{
			// TODO Auto Generated method stub
			trace("error getting stuff types");
		}
		
		private function initMousePointer():void
		{
			if(isWearingRod()){
				for each(var i:DisplayObject in initMCs)
				{
					MousePointer.registerObject(i, MousePointer.ACTION);
				}
			} else {
				removeMousePointer();
			}
			
		}
		
		private function removeMousePointer():void 
		{
			for each(var i:DisplayObject in initMCs)
			{
				MousePointer.unRegisterObject(i);
			}
			
			MousePointer.resetIcon();
		}
		
		private function isWearingRod():Boolean 
		{
			if(stuffs.isItemUsed(BASIC_ROD_NAME))
			{
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
			
			var char:LocationChar = _location.chars[Global.charManager.charId];
			
			if	(char != null)
				char.setModel(CharModels.STAY, Directions.getDirection(lastMouseX - char.content.x, lastMouseY - char.content.y));
			
			trace("gonna fish...");
			var time:int = MathUtils.randomNumberRange(15, 35);
			trace("waiting -> " + time + " secs");
			
			fishTimer = new Timer(time * 1000, 0);
			fishTimer.addEventListener(TimerEvent.TIMER, onFishTimer);
			showFishingAnimations();
			fishTimer.start();
			
			
			
			removeMousePointer();
		}
		
		private function showFishingAnimations():void
		{
			// TODO: work on fishing animations showing, when player puts rod in water.. catches fish etc
			
		}
		
		protected function onFishTimer(event:TimerEvent = null):void
		{
			if(Global.isFishing)
			{
				var weights:Array = [];
				
				for each(var fish:FishType in getFishiesByRod(BASIC_ROD_NAME)){

					//trace("added fishie " + fish.name);
					weights.push(fish.probability);
				}
				
				
				processFish(MathUtils.randomIndexByWeights(weights));
			}
			
		}
		
		private function processFish(prob:int):void 
		{
			var fishs:Array = getFishiesByRod(BASIC_ROD_NAME);
			var le_fish:FishType = fishs[prob];
			
			
			
			
			if(le_fish == null)
				return;
			var selc_fish:FishType = le_fish;
			trace(selc_fish.name);
			endFish();
			
			// award fish 
			
			if(le_fish.name == "null")
			{
				Dialogs.showOkDialog("The fish swam away, darn it!", true);
				return;
			}
				
				
		    if(!le_fish.isItem)
			{
				processBugs(le_fish);
				return;
			} else {
				
				(canGetMoreFish()) ? new RetriveStuffCommand(le_fish.name, "").execute() : Dialogs.showOkDialog("Your fishermans backpack is full!", true);
				if(!canGetMoreFish())
					return;
			}
				
			var msg:String = "Yay You've caught a " + le_fish.nice_name;
			doIHaveFish(le_fish.name);
			
			Dialogs.showOkDialog(msg, true);
			
			if(le_fish.probability < 21 )
				Global.addExperience(1);
				
		}
		
		private function canGetMoreFish():Boolean
		{
			var maxFish:int = (Global.charManager.isCitizen) ? 10 : 5;
			//trace("is mod? " + Global.charManager.isModerator);
			if(Global.charManager.isModerator){
				maxFish = 99999;
			}
				
			return !(stuffs.getStuffsCount(StuffTypes.FISH) >= maxFish);
		}
		
		public function doIHaveFish(fishName:String = ""):void
		{
			// testing
			
			trace("do i have this fish? " + stuffs.stuffExists(fishName));
		}
		
		private function processBugs(le_fish:FishType):void
		{
			var bugs:int = getRandomBugs();
			
			if(!le_fish.isItem && le_fish.name == "bugs")
			{
				trace("giving bugs");
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
		
		private function getFishiesByRod(rod:String):Array
		{
			var fis:Array = [];
			
			for each(var o:Object in fishies){
				if(o.name == rod)
				{
					fis.push(o.fish);
					
				}
			}
			
			return fis;
		}
		
		private function endFish():void 
		{
			if(!Global.isFishing)
				return;
			
			initMousePointer();
			Global.isFishing = false;
			if(fishTimer != null)
				fishTimer.stop();
		}
		
		override public function destroy():void
		{
			trace("deactived.... destroyed");
			Global.charManager.charViewChangeEvent.removeListenerIfHas(onCharChangedEvent);
			super.destroy();
		}
		
		override public function goIn():void
		{
			trace("going in to fishing");

			if(!Global.isFishing)
				doFish();
			
			super.goIn();
		}
		
		override public function goOut():void
		{
			trace("leaving fishing");
			
			if(Global.isFishing) 
				endFish();
			
			super.goOut();
		}
		
		override protected function onClick(event : MouseEvent) : void
		{
			var mc:MovieClip = MovieClip(event['currentTarget']);
			
			trace("on click " + event['currentTarget']);
			if (mc.hitTestPoint(
				Global.stage.mouseX,
				Global.stage.mouseY) && isWearingRod())
			{
				if(Global.isFishing) 
					return;
				trace("activated fishing...");
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