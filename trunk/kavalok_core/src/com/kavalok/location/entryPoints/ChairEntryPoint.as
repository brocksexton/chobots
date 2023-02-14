package com.kavalok.location.entryPoints
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.Directions;
	import com.kavalok.char.LocationChar;
	import com.kavalok.constants.Modules;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.actions.PlaceCocktailAction;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Sequence;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.Timers;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	

	public class ChairEntryPoint extends EntryPointBase
	{
		private static const COCKTAIL_TIME : Number = 32000;
		public static const TABLE_PREFIX : String = "table_";
		private static const COCKTAIL_PREFIX : String = "cocktail_";
		
		private static var _cocktailsCount : uint = 0;
		
		private var _points : Array = [];
		private var _currentChairId : String = null; 
		private var _table : MovieClip;
		private var _cocktails : Object = {};
		private var _enabled:Boolean = true;
		private var _usedStuffs:Array;
		private var _entered:Boolean = false;
		
		public function ChairEntryPoint(location : LocationBase)
		{
			_location = location;
			super(location, 'chair', location.remoteId);
		}
		
		override public function initialize(mc:MovieClip):void
		{
			mc.mcPos.visible = false;
			mc.mcHitArea.alpha = 0;
			GraphUtils.removeChildren(mc.mcPoint);
			getTable(mc).cocktailsPlace.background.visible = false;
			_points.push(mc);
			MousePointer.registerObject(getTable(mc).catalog, MousePointer.ACTION);
			getTable(mc).catalog.visible = false;
			MousePointer.registerObject(mc.mcHitArea, MousePointer.ACTION);
		}
		
		override public function get charPosition():Point 
		{
			var point:Point = new Point(clickedClip.mcPos.x, clickedClip.mcPos.y);
			GraphUtils.transformCoords(point, clickedClip, clickedClip.parent);
			return point;
		}
		
		private function get catalog() : MovieClip
		{
			return _table.catalog;
		}
		
		public function registerCocktail(id : String, movie : MovieClip) : void
		{
			_cocktails[id] = movie;
		}
		
		override protected function onClick(event : MouseEvent) : void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			if (mc.mcHitArea.hitTestPoint(
				Global.stage.mouseX,
				Global.stage.mouseY))
			{
			
				clickedClip = mc;
				activateEvent.sendEvent(this);
			}
		}
		
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			for (var stateId:String in states)
			{
				if(Strings.startsWidth(stateId, COCKTAIL_PREFIX))
				{
					var cockState : Object = states[stateId];
					if(states[cockState.userState] == null)
					{
						removeState("rRemoveCocktail", stateId);
					}
				}
			}
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			_location.readyEvent.addListener(onLocationReady);
		}
		
		private function onLocationReady():void
		{
			sendUserState(null, {});
			for (var stateId:String in states)
			{
				if(Strings.startsWidth(stateId, COCKTAIL_PREFIX))
				{
					var cockState : Object = states[stateId];
					if(states[cockState.userState] == null)
					{
						removeState(null, stateId);
					}
					else
					{
						rPlaceCocktail(stateId, cockState);
					}
				}
				else 
				{
					rPlaceChar(stateId, states[stateId]);
				}
			}
		}
		
		private function get chairId():String
		{
			return _points.indexOf(clickedClip).toString();
		}
		
		override public function goIn():void
		{
			lockState('rLock', chairId);
			_entered = true;			
		}
		
		public function rLock(stateId:String, state:Object):void
		{
			if (!_entered || !_enabled || state.owner != clientCharId)
				return;
				
			_enabled = false;
			_usedStuffs = [];
			
			Global.frame.tips.addTip("sitTable");
			Global.charManager.stuffs.refreshEvent.addListener(onStuffRefresh);
			_currentChairId = stateId;
			_table = getTable(clickedClip);
			catalog.addEventListener(MouseEvent.CLICK, onCatalogClick);
			catalog.visible = true;
			catalog.alpha = 0;
			new Sequence(catalog, [{alpha:1},{alpha:0.1},{alpha:1},{alpha:0.1},{alpha:1}], 10);
			Global.charManager.removeStaticModifiers();
			sendState('rPlaceChar', chairId, {charId : clientCharId}, true);
			place(chairId, {charId : clientCharId});
		}
		
		override public function goOut():void
		{
			_entered = false;
			
			if(_table != null)
			{
				catalog.visible = false;
				catalog.removeEventListener(MouseEvent.CLICK, onCatalogClick);
				Global.charManager.stuffs.refreshEvent.removeListener(onStuffRefresh);
				_table = null;
			}
			
			if (_currentChairId != null)
			{
				var state:Object = {charId : '', owner : clientCharId};
				sendState('rUnPlaceChar', _currentChairId, state);
				unPlace(_currentChairId, state.owner);
				_currentChairId = null;
			}
		}
		
		public function rPlaceChar(stateId:String, state:Object):void
		{
			if (state.charId != clientCharId)
				place(stateId, state);
		}
		
		public function rUnPlaceChar(stateId:String, state:Object):void
		{
			if (state.owner != clientCharId)
				unPlace(stateId, state.owner);
		}

		private function getTable(clip : MovieClip) : MovieClip
		{
			var parts : Array = clip.name.split("_");
			return _location.charContainer[TABLE_PREFIX + parts[1]];
		}
		
		public function place(stateId:String, state:Object):void
		{
			_enabled = true;
			var char:LocationChar = _location.chars[state.charId];
			
			if (char)
			{
				var mc:MovieClip = _points[int(stateId)];
				var mcPoint:MovieClip = mc.getChildByName('mcPoint') as MovieClip;
				char.changeParent(mcPoint);
				if (Strings.startsWidth(mc.name, 'chair1'))
					char.setModel(CharModels.STAY, Directions.RIGHT_DOWN);
				else
					char.setModel(CharModels.STAY, Directions.RIGHT_UP);
			}
			else
			{
				removeState(null, stateId);
			}
			
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		private function onStuffRefresh():void
		{
			var cocktails:Array = Global.charManager.stuffs.getCocktails();
			
			for each(var item : StuffItemLightTO in cocktails)
			{
				if (String(item.id) in _usedStuffs)
					continue;
					
				_usedStuffs[item.id] = true;
				
				Global.charManager.stuffs.removeItem(item);
				var place : MovieClip = _table.cocktailsPlace;
				var cocktailState : Object = 
				{
					userState : userStateId
					, table : _table.name
					, file : item.fileName
					, x : Math.random()*place.background.width
					, y : Math.random()*place.background.height
				}
				var stateId : String = COCKTAIL_PREFIX + Strings.generateRandomId();
				sendState("rPlaceCocktail", stateId, cocktailState);
				Timers.callAfter(removeCocktail, COCKTAIL_TIME, this, [stateId]);
			}
		}
		
		private function removeCocktail(stateId : String):void
		{
			removeState("rRemoveCocktail", stateId);
		}
		
		public function rRemoveCocktail(stateId : String):void
		{
			if(_cocktails[stateId] != null)
			{
				var movie : MovieClip = _cocktails[stateId];
				if(movie && movie.parent)
				{
					movie.parent.removeChild(movie); 
					movie.stop();
				}
			}
		}
		
		public function rPlaceCocktail(stateId : String, state : Object):void
		{
			var action : PlaceCocktailAction = new PlaceCocktailAction(this, stateId, state, _location);
			Global.classLibrary.callbackOnReady(action.execute, [URLHelper.stuffURL(state.file, StuffTypes.COCKTAIL)]);
		}
		
		private function onCatalogClick(event:MouseEvent):void
		{
			Global.moduleManager.loadModule(Modules.STUFF_CATALOG, {shop : "cafe", countVisible : true});
		}
		
		private function unPlace(chairId:String, charId:String):void
		{
			var char:LocationChar = _location.chars[charId];
			var mc:MovieClip = _points[int(chairId)];
			
			if (char)
				char.restoreParent();
			
		}
		
	}
}