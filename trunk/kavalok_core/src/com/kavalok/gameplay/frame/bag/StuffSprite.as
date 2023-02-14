package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.URLHelper;
	import com.kavalok.dto.stuff.StuffTOBase;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class StuffSprite extends Sprite
	{
		public var color:int = -1;
		public var colorSec:int = -1;
		public var item:StuffTOBase;
		public var url:String;
		
		private var _pressEvent:EventSender = new EventSender();
		private var _overEvent:EventSender = new EventSender();
		private var _refreshEvent:EventSender = new EventSender();
		private var _outEvent:EventSender = new EventSender();
		
		private var _content:ResourceSprite;
		private var _loaded:Boolean = false;
		private var _enabled:Boolean;
		private var _disableFilters:Array;
		private var _star:Sprite;
		private var _ready:Boolean = false;
		
		public function StuffSprite(info:StuffTOBase, enabled : Boolean = true)
		{
			this.item = info;
			_enabled = enabled;
			url = URLHelper.stuffURL(item.fileName, item.type);
		}
		
		public function setSize(width:Number, height:Number):void
		{
			GraphUtils.scale(_content, height, width);
		}
		
		public function createModels():void
		{
			_content = item.createModel();
			_content.readyEvent.addListener(onSpriteReady);
			_content.cacheAsBitmap = true;
			_content.buttonMode = true;
			addChild(_content);
			if (_star)
				 addChild(_star);
		}
		
		public function loadModel():void
		{
			 if (!_loaded)
			 {
			 	_loaded = true;
			 	_content.loadContent();
			 }
		}
		
		private function onSpriteReady(sender:Object):void
		{
			GraphUtils.addBoundsRect(_content);
			
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			_content.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_content.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			GraphUtils.stopAllChildren(_content);
			refreshEnabled();
			_ready = true;
			_refreshEvent.sendEvent(this);
		}
		
		private function refreshEnabled():void
		{
			_content.filters = (_enabled) ? [] : getDisableFilters();
			_content.alpha = (_enabled) ? 1 : 0.5;
		}
		
		private function getDisableFilters():Array
		{
			if (!_disableFilters)
				_disableFilters = new McDisabledFilter().filtersObject.filters;
			return _disableFilters; 
		}
		
		private function onOut(e:MouseEvent):void
		{
			if(_enabled)
				_outEvent.sendEvent(this);
		}
		
		private function onOver(e:MouseEvent):void
		{
			if(_enabled)
				_overEvent.sendEvent(this);
		}
		
		private function onPress(e:MouseEvent):void
		{
			if(_enabled)
				_pressEvent.sendEvent(this);
		}
		
		private function destroy():void
		{
			_content.destroy();
		}
		
		public function set star(value:Sprite):void
		{
			if (_star)
				GraphUtils.detachFromDisplay(_star);
			_star = value;
			if (_star)
				addChild(_star);
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value : Boolean) : void
		{
			_enabled = value;
			if (_content.content)
				refreshEnabled();
		}
		
		public function get overEvent():EventSender { return _overEvent; }
		public function get outEvent():EventSender { return _outEvent; }
		public function get refreshEvent():EventSender { return _refreshEvent; }
		
		public function get ready():Boolean { return _ready; }
		public function get hasColor():Boolean { return item.hasColor; }
		public function get doubleColor():Boolean { return item.doubleColor; }
		public function get pressEvent():EventSender { return _pressEvent; }
	}
	
}