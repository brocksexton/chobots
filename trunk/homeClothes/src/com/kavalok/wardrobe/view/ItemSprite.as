package com.kavalok.wardrobe.view
{
	import assets.wardrobe.McOutFilters;
	import assets.wardrobe.McOverFilters;
	import assets.wardrobe.McSelectedFilters;
	
	import com.kavalok.Global;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.gameplay.ToolTips;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	public class ItemSprite extends Sprite
	{
		static private var _overFilters:Array;
		static private var _outFilters:Array;
		static private var _selectedFilters:Array;
		static private var _disabledFilters:Array; 
		
		private var _stuff:StuffItemLightTO;
		private var _model:ResourceSprite;
		private var _dragManager:DragManager;
		
		private var _startDragEvent:EventSender = new EventSender();
		private var _finishDragEvent:EventSender = new EventSender();
		private var _dragEvent:EventSender = new EventSender();
		
		private var _recycled:Boolean = false;
		private var _colored:Boolean = false;
		private var _marketed:Boolean = false;
		private var _selected:Boolean = false;
		
		public function ItemSprite(stuff:StuffItemLightTO)
		{
			_stuff = stuff;

			
			if (!_overFilters)
			{
				_overFilters = GraphUtils.getFilters(McOverFilters);
				_outFilters = GraphUtils.getFilters(McOutFilters);
				_selectedFilters = GraphUtils.getFilters(McSelectedFilters);
				_disabledFilters = GraphUtils.getFilters(McDisabledFilter)
			}
			
			refresh();
			visible = !_stuff.used;
			
			if (enabled)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				this.filters = _outFilters;
			}
			else
			{
				this.filters = _disabledFilters;
			}
			
		}
		
		public function get initialized():Boolean
		{
			 return Boolean(_model);
		}
		
		public function initialize():void
		{
			_model = _stuff.createModel();
			_model.loadContent();
			GraphUtils.addBoundsRect(_model);
			
			_dragManager = new DragManager(this);
			_dragManager.dragAlpha = 1;
			_dragManager.startEvent.addListener(onStartDrag);
			_dragManager.finishEvent.addListener(onFinishDrag);
			_dragManager.dragEvent.addListener(onDrag);
			
			this.addChild(_model);
			this.cacheAsBitmap = true;
			this.buttonMode = true;
			if(_stuff.name != "" && _stuff.name != null)
			ToolTips.registerObject(_model, _stuff.name);
		}
		
		public function deactivate():void
		{
			_dragManager.enabled = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			if (_selected != value)
			{
				_selected = value;
				if (enabled)
				{
					if (_selected)
						this.filters = _selectedFilters;
					else
						this.filters = _overFilters;
				}
			}
		}
		
		
		public function get isNewStaff():Boolean
		{
			return _stuff.position.x == 0;
		}
		
		public function set position(value:Point):void
		{
			_stuff.position = value;
			refresh();
		}
		
		private function refresh():void
		{
			this.x = _stuff.position.x;
			this.y = _stuff.position.y;
		}
		
		public function updatePosition():void
		{
			_stuff.position = new Point(this.x, this.y);
		}
		
		private function onStartDrag(dm:DragManager):void
		{
			_startDragEvent.sendEvent(this);
		}
		
		private function onFinishDrag(dm:DragManager):void
		{
			_finishDragEvent.sendEvent(this);
		}
		
		private function onDrag(dm:DragManager):void
		{
			_dragEvent.sendEvent(this);
		}
		
		private function onOut(e:MouseEvent):void
		{
			this.filters = _outFilters;
		}
		
		private function onOver(e:MouseEvent):void
		{
			this.filters = _overFilters;
		}
		
		public function get enabled():Boolean
		{
			 return !(_stuff.premium && !Global.charManager.isCitizen);
		}
		
		public function set recycled(value:Boolean):void
		{
			 if (value != _recycled)
			 {
			 	_recycled = value;
			 	if (_recycled)
			 		this.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 100);
			 	else
			 		this.transform.colorTransform = new ColorTransform();
			 }
		}

		public function set marketed(value:Boolean):void
		{
			 if (value != _marketed)
			 {
			 	_marketed = value;
			 	if (_marketed)
			 		this.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 100);
			 	else
			 		this.transform.colorTransform = new ColorTransform();
			 }
		}
		
		public function set colored(value:Boolean):void
		{
			 if (value != _colored)
			 {
			 	_colored = value;
			 	if (_colored)
			 		this.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 100);
			 	else
			 		this.transform.colorTransform = new ColorTransform();
			 }
		}
		
		public function get stuff():StuffItemLightTO { return _stuff; }
		public function get placement():String { return _stuff.placement; }
		public function get id():int { return _stuff.id; }
		public function get recycled():Boolean { return _recycled; }
		public function get marketed():Boolean { return _marketed; }
		public function get colored():Boolean { return _colored; }
		
		public function get startDragEvent():EventSender { return _startDragEvent; }
		public function get finishDragEvent():EventSender { return _finishDragEvent; }
		public function get dragEvent():EventSender { return _dragEvent; }
		public function get dragManager():DragManager { return _dragManager; }
		
	}
	
}