package com.kavalok.gameplay
{
	import com.kavalok.Global;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	public class MousePointer
	{
		public static const WALK:Class = McPointerWalk;
		public static const HAND:Class = McPointerHand;
		public static const BLOCKED:Class = McPointerBlocked; 
		public static const ACTION:Class = McPointerAction;
		public static const EXIT:Class = McPointerExit;
		public static const BUSY:Class = McPointerBusy;
		public static const TARGET:Class = McPointerTarget;
		public static const FINGER:Class = McPointerFinger;
		
		private static var _icon:MovieClip; 
		private static var _list:Dictionary = new Dictionary(true);
		private static var _container:Sprite; 
		
		public static function get pointer():MovieClip
		{
			return _icon;
		}
		public static function setIcon(icon:MovieClip, hideMouse:Boolean = true):void
		{
			if (!_container)
				_container = Global.root;
			
			resetIcon();
			
			_icon = icon;
			_icon.mouseEnabled = false;
			_icon.mouseChildren = false;
			_icon.stop();
			
			_container.addChild(_icon);
			_container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if (hideMouse)
			{
				Mouse.hide();
			}
			
			update();
		}
		
		public static function setIconClass(iconClass:Class, hideMouse:Boolean = true):void
		{
			if (!(_icon is iconClass))
			{
				var icon:MovieClip = new iconClass();
				setIcon(icon, hideMouse);
			}
		}
		
		public static function registerObject(sprite:DisplayObject, iconClass:Class, hideMouse:Boolean = true):void
		{
			if(sprite == null)
				return;
			var info:SpriteInfo = new SpriteInfo();
			
			info.iconClass = iconClass;
			info.hideMouse = hideMouse;
			
			sprite.addEventListener(MouseEvent.MOUSE_OVER, onSpriteOver);
			sprite.addEventListener(MouseEvent.MOUSE_OUT, onSpriteOut);
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onSpriteDown);
			sprite.addEventListener(MouseEvent.MOUSE_UP, onSpriteUp);
			
			if (sprite.hitTestPoint(Global.stage.mouseX, Global.stage.mouseY, true))
			{
				setIconClass(info.iconClass, info.hideMouse);
			}
			
			_list[sprite] = info;
		}
		
		public static function unRegisterObject(sprite:DisplayObject):void
		{
			if(sprite == null)
				return;
			sprite.removeEventListener(MouseEvent.MOUSE_OVER, onSpriteOver);
			sprite.removeEventListener(MouseEvent.MOUSE_OUT, onSpriteOut);
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN, onSpriteDown);
			sprite.removeEventListener(MouseEvent.MOUSE_UP, onSpriteUp);
			
			delete _list[sprite];
		}
		
		private static function onSpriteOver(e:MouseEvent):void
		{
			var info:SpriteInfo = _list[e.currentTarget];
			setIconClass(info.iconClass, info.hideMouse);
		}
		
		private static function onSpriteDown(e:MouseEvent):void
		{
			var sprite:DisplayObject = DisplayObject(e.currentTarget);
			
			if (_icon)
				_icon.gotoAndStop(2);
		}
		
		private static function onSpriteUp(e:MouseEvent):void
		{
			var sprite:DisplayObject = DisplayObject(e.currentTarget);
			
			if (_icon)
				_icon.gotoAndStop(1);
		}
		
		private static function onSpriteOut(e:MouseEvent):void
		{
			resetIcon();
		}
		
		public static function resetIcon():void
		{
			if (_icon)
			{
				_container.removeChild(_icon);
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				_icon = null;
			}
			
			Mouse.show();
		}
		
		private static function onMouseMove(e:MouseEvent):void
		{
			update();
			
			if (Global.locationManager.location && 
				Global.locationManager.location.remote.connectedChars.length < 50)
			{
				e.updateAfterEvent();
			}
		}
		
		private static function update():void
		{
			_icon.x = _container.mouseX;
			_icon.y = _container.mouseY;
		}

	}
}

internal class SpriteInfo
{
	public var iconClass:Class;
	public var hideMouse:Boolean;
}