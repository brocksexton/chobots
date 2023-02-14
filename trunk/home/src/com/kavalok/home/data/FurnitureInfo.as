package com.kavalok.home.data
{
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.RectangleSprite;
	import com.kavalok.home.FurnitureRotationView;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.SpriteDecorator;
	
	import flash.display.MovieClip;
	
	public class FurnitureInfo
	{
		private static const BUTTONS_HEIGHT : int = 20;
		
		public var view : MovieClip;
		public var drag : MovieClip;
		public var item : StuffItemLightTO;
		public var container : RectangleSprite;
		public var dragManager : DragManager;
		public var rotationView : FurnitureRotationView;
		
		private var _changeEvent : EventSender = new EventSender();
		private var _removeEvent : EventSender = new EventSender();
		
		public function FurnitureInfo(item : StuffItemLightTO, view : MovieClip, drag : MovieClip)
		{
			this.view = view;
			this.item = item;
			this.drag = drag;
			container = new RectangleSprite(view.width, view.height + BUTTONS_HEIGHT);
			container.borderAlpha = 0;
			container.backgroundAlpha = 0;
			container.addChild(view);
			rotationView = new FurnitureRotationView(container, view, drag, item);
			rotationView.changeEvent.addListener(onRotationChange);
			rotationView.removeEvent.addListener(onRemove);
			rotationView.rotation = item.rotation;
			dragManager = new DragManager(container, view);
			drag.alpha = 0;
			if (item.color >= 0)
				SpriteDecorator.decorateColor(view, item.color, 0) 
		}
		
		public function set enabled(value : Boolean) : void
		{
			dragManager.enabled = value;
			rotationView.enabled = value;
		}
		public function updatePosition() : void
		{
			item.x = container.x;
			item.y = container.y;
			drag.x = container.x;
			drag.y = container.y;
			rotationView.reset();
		}
		public function resetPosition() : void
		{
			container.x = item.x;
			container.y = item.y;
			drag.x = item.x;
			drag.y = item.y;
			rotationView.reset();
		}
		private function onRotationChange() : void
		{
			item.rotation = rotationView.rotation;
			changeEvent.sendEvent(this);
		}
		
		private function onRemove():void
		{
			_removeEvent.sendEvent(this);
		}
		
		public function get changeEvent() : EventSender { return _changeEvent; }
		
		public function get removeEvent():EventSender { return _removeEvent; }
	}
}