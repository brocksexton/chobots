package org.goverla.flash.skining
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import mx.controls.Label;
	import mx.core.UIComponent;

	[Style(name="skin", type="Class", inherit="no")]
	public class FlashSkinedButton extends UIComponent
	{
		private static const SKIN : String = "skin";
		private static const DISABLED_FRAME : uint = 4;
		private static const UP_FRAME : uint = 1;
		private static const DOWN_FRAME : uint = 3;
		private static const OVER_FRAME : uint = 2;
		private static const TOGGLE_UP_FRAME : uint = 5;
		private static const TOGGLE_OVER_FRAME : uint = 6;
		private static const TOGGLE_DOWN_FRAME : uint = 7;
		private static const TOGGLE_DISABLED_FRAME : uint = 8;
		
		[Bindable]
		public var data : Object;

		private var _toggle:Boolean;
		private var _selected:Boolean;
		private var _isOver : Boolean;
		private var _isDown:Boolean;

		private var _changeFrame : Boolean;
		
		private var _skin : MovieClip;
		
		private var _relatedLabel : Label;

		public function FlashSkinedButton()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		[Bindable]		
		public function get relatedLabel() : Label
		{
			return _relatedLabel;
		}

		public function set relatedLabel(value : Label) : void
		{
			if(_relatedLabel != value)
			{
				if(_relatedLabel != null)
				{
					_relatedLabel.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					_relatedLabel.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					_relatedLabel.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					_relatedLabel.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					_relatedLabel.removeEventListener(MouseEvent.CLICK, onRelatedClick);
					
				}
				_relatedLabel = value;
				if(_relatedLabel != null)
				{
					_relatedLabel.enabled = enabled;
					_relatedLabel.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					_relatedLabel.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					_relatedLabel.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					_relatedLabel.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					_relatedLabel.addEventListener(MouseEvent.CLICK, onRelatedClick);
				}
			}
			
		}
		
		
		[Bindable]
		public function get isDown():Boolean 
		{
			return _isDown;
		}

		public function set isDown(value:Boolean):void 
		{
			_isDown = value;
			updateIfEnabled();
		}
		[Bindable]
		public function get isOver():Boolean 
		{
			return _isOver;
		}

		public function set isOver(value:Boolean):void 
		{
			_isOver = value;
			updateIfEnabled();	
		}
		public function get toggle():Boolean 
		{
			return _toggle;
		}

		public function set toggle(value:Boolean):void 
		{
			if(value != _toggle)
			{
				_toggle = value;
				_changeFrame = true;
				invalidateDisplayList();
			}
		}

		public function get selected():Boolean 
		{
			return _selected;
		}

		public function set selected(value:Boolean):void 
		{
			if(!toggle)
				return;
			if(_selected != value)
			{
				_selected = value;
				_changeFrame = true;
				invalidateDisplayList();
			}
		}

		override public function get enabled():Boolean 
		{
			return super.enabled;
		}
		
		[Bindable]
		override public function set enabled(value:Boolean):void 
		{
			if(value != enabled)
			{
				super.enabled = value;
				_changeFrame = true;
				invalidateDisplayList();
				if(_relatedLabel != null)
				{
					_relatedLabel.enabled = value;
				}
			}
		}
		
		override public function setStyle(styleProp:String, newValue:*):void
		{
			if(styleProp == SKIN)
			{
				if(_skin != null)
				{
					removeChild(_skin);
				}
				_skin = new newValue();
				addChild(_skin);
				_changeFrame = true;
				invalidateDisplayList();
			}
			super.setStyle(styleProp, newValue);
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_skin != null && _changeFrame)
			{
				_changeFrame = false;
				var frame : uint = toggle ? TOGGLE_UP_FRAME : UP_FRAME;
				if(_isOver)
				{
					frame = toggle ? TOGGLE_OVER_FRAME : OVER_FRAME;
				}
				if(_isDown)
				{
					frame = toggle ? TOGGLE_DOWN_FRAME : DOWN_FRAME;
				}
				if(selected)
				{
					frame = TOGGLE_DOWN_FRAME;
				}
				if(!enabled)
				{
					frame = toggle ? TOGGLE_DISABLED_FRAME : DISABLED_FRAME;
				}
				_skin.gotoAndStop(frame);
			}
		}
		
		private function updateIfEnabled() : void
		{
			if(enabled)
			{
				_changeFrame = true;
				invalidateDisplayList();
			}
		}
		
		
		private function onRelatedClick(event : MouseEvent) : void
		{
			if(!enabled)
			{
				event.stopImmediatePropagation();
			}
		}
		
		private function onMouseOver(event : MouseEvent) : void
		{
			isOver = true;
			updateIfEnabled();
		}

		private function onMouseOut(event : MouseEvent) : void
		{
			isOver = false;
			isDown = false;
			updateIfEnabled();
		}

		private function onMouseDown(event : MouseEvent) : void
		{
			if(!enabled)
				return;
			if(toggle)
			{
				selected = !selected;
			}
			
			isDown = true;
			updateIfEnabled();
		}

		private function onMouseUp(event : MouseEvent) : void
		{
			isDown = false;
			updateIfEnabled();
		}

		private function onClick(event : MouseEvent) : void
		{
			if(!enabled)
			{
				event.stopImmediatePropagation();
			}
		}
		
		
		
	}
}