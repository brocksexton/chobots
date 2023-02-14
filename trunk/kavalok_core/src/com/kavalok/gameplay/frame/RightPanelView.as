package com.kavalok.gameplay.frame
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class RightPanelView extends FlashViewBase
	{
		private static const FRAMES : Number = 8;
			
		private var _openPosition : Number = 678;
		private var _pin:Boolean;
	
		private var _open:Boolean;
		private var _tweener:SpriteTweaner;
		private var _startX : Number;
		private var _content : RightPanel;
		private var _childContent : Sprite;
		
		public function RightPanelView(content : RightPanel)
		{
			super(content)
			_content = content;
			_content.visible = false;
			_startX = content.x;

			_content.pinButtonPressed.visible = false;
			_content.pinButton.addEventListener(MouseEvent.CLICK, onPinClick);
			_content.pinButtonPressed.addEventListener(MouseEvent.CLICK, onPinPressedClick);
		}
		
		public function get childContent() : Sprite
		{
			return _childContent;
		}
		
		public function set childContent(value : Sprite) : void
		{
			if(_childContent != null)
				_content.container.removeChild(_childContent);
				
			_content.container.addChild(value);
			
			_childContent = value;
		}
		
		public function get open():Boolean
		{
			return _open;
		}

		public function set open(value:Boolean):void
		{
			if(open != value)
			{
				_open = value;
				stopTween();
				if(value)
				{
					_content.visible = true;
					Global.root.addEventListener(MouseEvent.CLICK, onAppClick);
					Global.locationManager.locationDestroy.addListener(onLocationChange);
					_tweener = new SpriteTweaner(_content, {x:_openPosition}, FRAMES);
				}
				else
				{
					Global.root.removeEventListener(MouseEvent.CLICK, onAppClick);
					Global.locationManager.locationDestroy.removeListener(onLocationChange);
					_tweener = new SpriteTweaner(_content, {x:_startX}, FRAMES);
					_tweener.complete.addListener(onHide);
				}
			}
		}
		
		public function setOpen() : void
		{
			if(open)
				return;
			_open = true;
			stopTween();
			_content.visible = true;
			Global.root.addEventListener(MouseEvent.CLICK, onAppClick);
			Global.locationManager.locationDestroy.addListener(onLocationChange);
			_content.x = _openPosition;
		}
		
		private function onHide():void
		{
			_content.visible = false;			
		}

		private function set pin(value : Boolean) : void
		{
			_content.pinButton.visible = !value;
			_content.pinButtonPressed.visible = value;
			_pin = value;
		}

		private function stopTween() : void
		{
			if(_tweener != null)
			{
				_tweener.stop();
				_tweener = null;
			}
		}
		private function onTweenComplete() : void
		{
			stopTween();
		}
		private function onPinClick(event : MouseEvent) : void
		{
			pin = true;
			event.stopPropagation();
		}
		

		private function onPinPressedClick(event : MouseEvent) : void
		{
			pin = false;
			event.stopPropagation();
		}
		private function onAppClick(event : MouseEvent) : void
		{
			if(!_pin && !_content.hitTestPoint(event.stageX, event.stageY, true))
			{
				open = false;
			}
		}
		
		private function onLocationChange() : void
		{
			if(!_pin) 
			{
				open = false;
			}
		}
		
		private function onCloseClick(event : MouseEvent) : void
		{
			open = false;
		}
		
		public function get isPin():Boolean
		{
			 return _pin;
		}

	}
}