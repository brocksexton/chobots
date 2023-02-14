package com.kavalok.gameplay
{
	import com.kavalok.Global;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Maths;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	
	public class ToolTips
	{
		private static const OFFSET_Y:int = 10;

		private static var _tooltip:ToolTipText; 
		private static var _list:Dictionary = new Dictionary(true);
		private static var _container:Sprite; 
		
		public static function showText(messageId:String, bundle : String):void
		{
			if (!_container)
				_container = Global.root;
			
			hideText();
			
			createTooltip(messageId, bundle);
			
			_container.addChild(_tooltip);
			_container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			update();
		}
		
		private static function createTooltip(messageId:String, bundleId : String):void
		{
			
			_tooltip = new ToolTipText();
			
			if (bundleId)
			{
				var bundle : ResourceBundle = Localiztion.getBundle(bundleId);
				bundle.registerMessage(_tooltip, "text", messageId);
			}
			else
			{
				_tooltip.text = messageId;
			}
		}
		
		public static function hideText():void
		{
			if (_tooltip)
			{
				_container.removeChild(_tooltip);
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				_tooltip = null;
			}
		}
		
		private static function onMouseMove(e:MouseEvent):void
		{
			update();
			e.updateAfterEvent();
		}
		
		private static function update():void
		{
			var x : Number = _container.mouseX - _tooltip.width;
			var y : Number = _container.mouseY + OFFSET_Y;
			
			_tooltip.x = Maths.normalizeValue(x, 0, KavalokConstants.SCREEN_WIDTH - _tooltip.width);
			_tooltip.y = Maths.normalizeValue(y, 0, KavalokConstants.SCREEN_HEIGHT - _tooltip.height);
			
			//GraphUtils.claimBounds(_tooltip,
			//	new Rectangle(0, 0, KavalokConstants.SCREEN_WIDTH, KavalokConstants.SCREEN_HEIGHT));
		}
		
		public static function registerObject(sprite:DisplayObject, message:String, bundle : String = null):void
		{
			unRegisterObject(sprite);
			var info:SpriteInfo = new SpriteInfo();
			
			info.messageId = message;
			info.bundle = bundle;
			
			sprite.addEventListener(MouseEvent.MOUSE_OVER, onSpriteOver);
			sprite.addEventListener(MouseEvent.MOUSE_OUT, onSpriteOut);
			
			if (sprite.hitTestPoint(Global.stage.mouseX, Global.stage.mouseY, true))
			{
				showText(info.messageId, info.bundle);
			}
			
			_list[sprite] = info;
		}
		
		public static function unRegisterObject(sprite:DisplayObject):void
		{
			if(_list[sprite])
			{
				sprite.removeEventListener(MouseEvent.MOUSE_OVER, onSpriteOver);
				sprite.removeEventListener(MouseEvent.MOUSE_OUT, onSpriteOut);
				
				delete _list[sprite];
				hideText();
			}
		}
		
		private static function onSpriteOver(e:MouseEvent):void
		{
			var info:SpriteInfo = _list[e.currentTarget];
			showText(info.messageId, info.bundle);
		}
		
		private static function onSpriteOut(e:MouseEvent):void
		{
			hideText();
		}
		
	}
}
	import com.kavalok.localization.Localiztion;
	

internal class SpriteInfo
{
	public var messageId:String;
	public var bundle : String;
	
	public function get message() : String
	{
		if(bundle == null)
			return messageId;
		var result : String = Localiztion.getBundle(bundle).messages[messageId];	
		return result == null ? messageId : result;
	}
}