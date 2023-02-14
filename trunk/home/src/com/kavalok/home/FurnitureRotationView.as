package com.kavalok.home
{
	import com.kavalok.Global;
	import com.kavalok.char.Stuffs;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FurnitureRotationView
	{
		private static const LEFT : int = 0;
		private static const RIGHT : int = 1;
		
		static private var _isDragging : Boolean;
		
		private var _changeEvent : EventSender = new EventSender();
		private var _removeEvent : EventSender = new EventSender();
		
		private var _rotation : int;
		private var _view : MovieClip;
		private var _container : Sprite;
		private var _drag : MovieClip;
		private var _leftButton : McFurnitureRotateButton;
		private var _rightButton : McFurnitureRotateButton;
		private var _removeButton : McFurnitureRemoveButton
		private var _item : StuffItemLightTO;
		private var _enabled : Boolean;
		private var _isOver : Boolean;
		private var _icon : Sprite;
		
		public function FurnitureRotationView(container : Sprite, view : MovieClip, drag : MovieClip, item : StuffItemLightTO)
		{
			_view = view;
			_drag = drag;
			_item = item;
			_container = container;
			
			_rightButton = new McFurnitureRotateButton();
			_rightButton.y = _view.height;
			_rightButton.x = _view.width;
			_rightButton.scaleX = -1;
			_rightButton.visible = false;
			_container.addChild(_rightButton);
			
			_leftButton = new McFurnitureRotateButton();
			_leftButton.y = _view.height;
			_container.addChild(_leftButton);
			_leftButton.visible = false;
			
			_removeButton = new McFurnitureRemoveButton();
			_removeButton.y = _view.height + 10;
			_removeButton.x = 0.5 * _view.width;
			_removeButton.visible = false;
			_container.addChild(_removeButton);
			
			_leftButton.addEventListener(MouseEvent.CLICK, onLeftClick);
			_rightButton.addEventListener(MouseEvent.CLICK, onRightClick);
			_removeButton.addEventListener(MouseEvent.CLICK, onRemoveClick);
			
			_container.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_container.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		public function set icon(value:Sprite):void
		{
			if (_icon)
				GraphUtils.detachFromDisplay(_icon);
			_icon = value;	
			if (_icon)
			{
				_icon.x = 0.5 * _view.width;
				_icon.y = _view.height;
				_container.addChild(_icon);
			}
		}
		
		public function get rotation() : int
		{
			return _rotation;
		}

		public function set rotation(value : int) : void
		{
			if(_view.totalFrames > 1)
			{
				_view.gotoAndStop(value);
			}
			else
			{
				if(value != _rotation)
				{
					rotate();
				}
				else
				{
					updatePosition();
				}
			}
			_rotation = value;
		}
		
		public function reset() : void
		{
			rotation = rotation;
		}
		
		public function set enabled(value : Boolean) : void
		{
			_enabled = value;
			refreshButtons();
		}
		
		public function set isDragging(value:Boolean):void
		{
			 _isDragging = value;
			 refreshButtons();
		}
		
		private function refreshButtons() : void
		{
			_leftButton.visible = _enabled && _isOver && !_isDragging;
			_rightButton.visible = _enabled && _isOver && !_isDragging;
			_removeButton.visible = _enabled && _isOver && !_isDragging;
		}
		
		private function onLeftClick(event : MouseEvent) : void
		{
			tryRotate(-1);
		}
		
		private function onRightClick(event : MouseEvent) : void
		{
			tryRotate(1);
		}
		
		private function onRemoveClick(event : MouseEvent) : void
		{
			var text:String = Strings.substitute(Global.messages.recycleWarning, _item.backPrice);
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(text);
			dialog.yes.addListener(dispatchRemove);
		}
		
		private function dispatchRemove():void
		{
			_removeEvent.sendEvent();
		}
		
		private function tryRotate(value : int) : void
		{
			if(_view.totalFrames > 1)
				addFrame(value);
			else
				rotate();
				
			changeEvent.sendEvent();
		}
		private function rotate() : void
		{
			_view.scaleX = -_view.scaleX;
			_drag.scaleX = _view.scaleX;
			_rotation = (_view.scaleX < 0) ? RIGHT : LEFT;
			updatePosition();
		}
		private function updatePosition() : void
		{
			_view.x = _rotation == LEFT ? 0 : _view.width;
			_drag.x = _view.x + _container.x;
		}
		private function addFrame(value : int) : void
		{
			var frame : int = _view.currentFrame + value;
			if(frame == 0)
				frame = _view.totalFrames;
			if(frame > _view.totalFrames)
				frame = 1;
			_view.gotoAndStop(frame);
			_drag.gotoAndStop(frame);
			_rotation = frame;
		}
		
		private function onRollOut(event : MouseEvent) : void
		{
			_isOver = false;
			refreshButtons();
			
		}
		private function onRollOver(event : MouseEvent) : void
		{
			_isOver = true;
			refreshButtons();
		}

		public function get removeEvent() : EventSender { return _removeEvent; }
		public function get changeEvent() : EventSender { return _changeEvent; }
	}
}