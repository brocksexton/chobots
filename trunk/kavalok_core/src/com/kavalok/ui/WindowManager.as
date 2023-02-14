package com.kavalok.ui
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.windows.CharWindowView;
	import com.kavalok.pets.PetWindowView;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class WindowManager
	{
		private var _windows:Object = {};
		private var _container:Sprite = Global.windowsContainer;
		
		public function WindowManager()
		{
		}
		
		public function showWindow(window:Window):void
		{
			_container.addChild(window.content);
			_windows[window.windowId] = window;
			
			window.closeEvent.addListener(onClose);
			window.content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			if (window.dragArea)
			{
				var dragManager:DragManager = new DragManager(window.content, window.dragArea, KavalokConstants.SCREEN_RECT);
				dragManager.startEvent.addListener(onDragStart);
				dragManager.finishEvent.addListener(onDragFinish);
				dragManager.tag = window;
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			GraphUtils.bringToFront(DisplayObject(e.currentTarget));
		}
		
		private function onClose(window:Window):void
		{
			closeWindow(window);
		}
		
		private function onDragStart(target:DragManager):void
		{
			Window(target.tag).alpha = 0.5;
		}
		
		private function onDragFinish(target:DragManager):void
		{
			Window(target.tag).alpha = 1;
		}
		
		public function activateWindow(window:Window):void
		{
			GraphUtils.bringToFront(window.content);
			window.onActivate();
		}
		
		public function closeWindow(window:Window):void
		{
			window.onClose();
			GraphUtils.detachFromDisplay(window.content)
			delete _windows[window.windowId];
		}
		
		public function hideAll():void
		{
			for each (var window:Window in _windows)
			{
				if (_container.contains(window.content))
				window.onClose();
					_container.removeChild(window.content);
			}
		}
		
		public function showAll():void
		{
			for each (var window:Window in _windows)
			{
				if (!_container.contains(window.content))
					_container.addChild(window.content);
			}
		}
		
		public function getWindow(id:String):Window
		{
			return _windows[id];
		}
		
		public function getCharWindow(charId:String):CharWindowView
		{
			return _windows[CharWindowView.getWindowId(charId)];
		}
		
		public function getPetWindow(petId:int):PetWindowView
		{
			return _windows[PetWindowView.getWindowId(petId)];
		}
	}
}