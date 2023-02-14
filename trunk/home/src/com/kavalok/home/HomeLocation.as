package com.kavalok.home
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dto.home.CharHomeTO;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.home.data.FurnitureInfo;
	import com.kavalok.home.modifiers.LocationEnterModifier;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.LocationManager;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ReflectUtil;
	import com.kavalok.utils.Timers;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	import com.kavalok.utils.comparing.RequirementsCollection;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class HomeLocation extends LocationBase
	{
		private static const POSITION_POINT : String = "defaultFurniturePosition";
		//private static const HOME_PREFIX : String = "charHome_";
		
		private var _dragContainer : Sprite = new Sprite();
		private var _char : String;
		private var _userId : int;
		
		private var _level : int;
		private var _home : CharHomeTO;
		private var _frame : HomeFrameView;

		private var _dragFinishEvent : EventSender = new EventSender();
		
		private var _editMode : Boolean;



		private var _lastDragManager : DragManager;

		private var _furnitures : Dictionary = new Dictionary();
		
		public function HomeLocation(char : String, userId : int, home : CharHomeTO, level : int, frame : HomeFrameView)
		{
			_level = level;
			_char = char;
			_home = home;
			_userId = userId;
			_frame = frame;
			var remoteId : String = LocationManager.getHomeRemoteId(char, level);

			super(Modules.HOME, remoteId);
			addModifier(new HomePartModifier(_home));
			addModifier(new LocationEnterModifier(this));
		//	trace(_home.rep);
		//	trace(_home.crit);
		}
		
		override public function get invitationParams():Object
		{
			var params : Object = super.invitationParams;
			params.charId = _char;
			params.userId = _userId;
			return params;
		}
		
		public function get dragFinishEvent() : EventSender
		{
			return _dragFinishEvent;
		}
		public function set editMode(value : Boolean) : void
		{
			_editMode = value;
			for each(var furnitureInfo : FurnitureInfo in _furnitures)
			{
				furnitureInfo.enabled = value;
			}
		}
		
		override public function restoreState(states:Object):void
		{
			super.restoreState(states);
			var req : RequirementsCollection = new RequirementsCollection();
			req.addItem(new PropertyCompareRequirement("used", true));
			req.addItem(new PropertyCompareRequirement("level", _level));
			var items : Array = Arrays.getByRequirement(_home.furniture, req);
			addFurnitureItems(items);
//			readyEvent.sendEvent();
		}
		

		public function addFurnitureItems(items : Array) : void
		{
//			if(!_home.citizen)
//				return;
			for each(var item : StuffItemLightTO in items)
				addFurnitureItem(item);
		}

		public function removeMyFurniture(info : FurnitureInfo) : void
		{
			removeFurnitureItem(info);
			saveFurnitureChange(info.item);
		}
		
		private function removeFurnitureItem(info : FurnitureInfo) : void
		{
			charContainer.removeChild(info.container);
			_dragContainer.removeChild(info.drag);
			info.item.used = false;
			info.dragManager.finishEvent.removeListeners();
			delete _furnitures[info.container];
			resetIgnoreArea();
		}

		public function addMyFurniture(item : StuffItemLightTO) : void
		{
//			if(!Global.charManager.isCitizen)
//				return;
			new LoadFurnitureCommand(this, item).execute();
			item.used = true;
			saveFurnitureChange(item);
		}
		public function addFurnitureItem(item : StuffItemLightTO) : void
		{
			new LoadFurnitureCommand(this, item).execute();
		}

		public function addFurnitureObject(item : StuffItemLightTO, view : MovieClip, drag : MovieClip) : void
		{
			var position : DisplayObject = content[POSITION_POINT];
			var info : FurnitureInfo = new FurnitureInfo(item, view, drag);
			info.enabled = _editMode;
			if(!item.used)
			{
				item.x = position.x;
				item.y = position.y;
				item.used = true;
				item.level = _level;
			}
			
			_dragContainer.addChild(drag);
			charContainer.addChild(info.container);
			info.dragManager.startEvent.addListener(onDragStart);
			info.dragManager.finishEvent.addListener(onDragFinish);
			info.dragManager.dragEvent.addListener(onDrag);
			info.resetPosition();
			_furnitures[info.container] = info;
			info.changeEvent.addListener(onFurnitureChange);
			info.removeEvent.addListener(onFurnitureRemove);
			resetIgnoreArea();
			
			modifyChildren(view);
			
		}
		
		override public function create():void
		{
			super.create();
			content[POSITION_POINT].visible = false;
			addPoint(new LevelEntryPoint(this, remoteId, _char, _userId, _home));
			content.addChildAt(_dragContainer, content.getChildIndex(charContainer));
		}
		
		private function sendUpdateFurniture(furniture : StuffItemLightTO) : void
		{
			send("rUpdateFurniture", furniture, clientCharId);
		}
		
		public function rUpdateFurniture(furniture : StuffItemLightTO, charId : String) : void
		{
			if(clientCharId == charId)
				return;
				
			var updated:Boolean = false;
			
			for each(var info : FurnitureInfo in _furnitures)
			{
				if(info.item.id == furniture.id)
				{
					updated = true;
					
					if(furniture.used)
					{
						ReflectUtil.copyFieldsAndProperties(furniture, info.item);
						info.rotationView.rotation = furniture.rotation;
						info.resetPosition();
					}
					else
					{
						removeFurnitureItem(info);
					}
					break;
				}
			}
			
			trace(updated);
			
			if(!updated) 
				addFurnitureItem(furniture);
			
			Timers.callAfter(resetIgnoreArea);
		}
		
		override protected function onUserMoveComplete():void
		{
			super.onUserMoveComplete();
			if(_lastDragManager && !_lastDragManager.finished)
			{
				_lastDragManager.stop();
				_lastDragManager.undoDrag();
			}
		}
		
		private function resetIgnoreArea() : void
		{
			pathBuilder.ignoreArea = _dragContainer;
		}
		private function onFurnitureChange(info : FurnitureInfo) : void
		{
			saveFurnitureChange(info.item);
		}
		private function saveFurnitureChange(item : StuffItemLightTO) : void
		{
			new StuffServiceNT().updateStuffItem(item);
			sendUpdateFurniture(item);
		}
		
		private function onFurnitureRemove(info : FurnitureInfo) : void
		{
			Global.charManager.stuffs.removeItem(info.item);
			var command : AddMoneyCommand = new AddMoneyCommand(info.item.backPrice, "recycle", false, null, false);
			command.citizenGetMore = false;
			command.execute();
			
			info.item.used = false;
			sendUpdateFurniture(info.item);
			
			Timers.callAfter(resetIgnoreArea);
			removeFurnitureItem(info)
		}
		
		
		private function onDrag(dragManager : DragManager) : void
		{
			var drag : Sprite = dragManager.content;
			var info : FurnitureInfo = _furnitures[drag];
			
			if(_frame.overBox)
			{
				info.rotationView.icon = new InCursor(); 
			}
			else if(!canDrag(dragManager))
			{
				info.rotationView.icon = new StopSign(); 
			}
			else
			{
				info.rotationView.icon = null; 
			} 
		}
		private function onDragStart(dragManager : DragManager) : void
		{
			_lastDragManager = dragManager;
			var drag : Sprite = dragManager.content;
			var info : FurnitureInfo = _furnitures[drag];
			info.rotationView.isDragging = true;
		}
		private function onDragFinish(dragManager : DragManager) : void
		{
			var drag : Sprite = dragManager.content;
			var info : FurnitureInfo = _furnitures[drag];
			info.rotationView.isDragging = false;
			if(!canDrag(dragManager))
			{
				info.resetPosition();
			}
			else
			{
				info.updatePosition();
				saveFurnitureChange(info.item);
				Timers.callAfter(resetIgnoreArea);
			}
			dragFinishEvent.sendEvent(info);
		}
		
		private function canDrag(dragManager : DragManager) : Boolean
		{
			var drag : Sprite = dragManager.content;
			var info : FurnitureInfo = _furnitures[drag];
			var controlPoints : Array = GraphUtils.getAllChildren(info.view, 
				new PropertyCompareRequirement("name", ResourceSprite.CONTROL_POINT));
			if(controlPoints.length == 0)
				controlPoints.push(drag);
				
			var result : Boolean = true;
			for each(var point : DisplayObject in controlPoints)
			{
				var coords : Point = GraphUtils.transformCoords(new Point(0,0), point, Global.stage);
				if(!ground.hitTestPoint(coords.x, coords.y, true))
				{
					result = false;
					break;
				}
			}
			return result;
		}
		
	}
}

