package com.kavalok.locGraphity
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.graphity.LineInfo;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	
	public class ToolView
	{
		private var _modeChangeEvent:EventSender = new EventSender();
		
		private var _content:McToolBar;
		private var _scroller:Scroller;
		private var _scrollProperty:String;
		
		private var _defaultSize:int;
		
		private var _color:int = 0;
		private var _size:Number = 0.1;
		private var _blur:Number = 0.05;
		private var _alpha:Number = 0.1;
		
		private var _enabled:Boolean = false;
		private var _modeButton:StateButton;
		
		public function ToolView(content:McToolBar)
		{
			_content = content;
			_color = int(Math.random() * 0xFFFFFF);
			
 			_scroller = new Scroller(_content.scroller);
 			_scroller.changeEvent.addListener(onScrollerChange);
 			_defaultSize = _content.sample.width;
 			
 			_modeButton = new StateButton(_content.modeButton);
 			_modeButton.stateEvent.addListener(onModeClick);
 			
 			initScrollControl(_content.sizeButton, "_size", 2);
 			initScrollControl(_content.blurButton, "_blur", 3);
 			initScrollControl(_content.alphaButton, "_alpha", 4);
 			initColorControl();
 			
			_content.nextButton.addEventListener(MouseEvent.CLICK, onNextClick) 
			_content.nextButton.visible = false;
			_content.nextButton.buttonMode = true;
			
			_content.colorPicker.colorPicker2.visible = false;
			_content.colorPicker.colorPicker2.visible = false;
			_content.colorPicker.colorPicker3.visible = false;
			
 			hideAll();
 			refresh();
 		}
 		
 		private function onModeClick(sender:StateButton):void
 		{
 			if (isDrawMode && _enabled)
 				setDrawMode()
 			else
 				setViewMode();
 		}
		
		private function onNextClick(e:MouseEvent):void
 		{
 			if(_content.colorPicker.colorPicker1.visible == true) {
				_content.colorPicker.colorPicker1.visible = false;
				_content.colorPicker.colorPicker2.visible = true;
			} else if(_content.colorPicker.colorPicker2.visible == true) {
				_content.colorPicker.colorPicker2.visible = false;
				_content.colorPicker.colorPicker3.visible = true;
			} else if(_content.colorPicker.colorPicker3.visible == true) {
				_content.colorPicker.colorPicker3.visible = false;
				_content.colorPicker.colorPicker1.visible = true;
			}
 		}
 		
 		public function setDrawMode():void
 		{
 			_modeButton.state = 1;
 			_modeChangeEvent.sendEvent();
 		}
 		
 		public function setViewMode():void
 		{
 			_modeButton.state = 2;
 			_modeChangeEvent.sendEvent();
 			hideAll();
 		}
 		
 		public function get isDrawMode():Boolean
 		{
 			 return _modeButton.state == 1;
 		}
 		
 		public function set enabled(value:Boolean):void
 		{
 			 if (value == _enabled)
 			 	return;
 			 
 			 _enabled = value;
 			 
 			 if (!_enabled)
 			 	hideAll();
 		}
 		
 		private function initColorControl():void
 		{
 			_content.colorPicker.addEventListener(MouseEvent.MOUSE_MOVE, refreshColor);
 			_content.colorPicker.addEventListener(MouseEvent.MOUSE_DOWN, applyColor);
 			_content.colorPicker.addEventListener(MouseEvent.MOUSE_OUT, refresh);
 			
 			var clickHandler:Function = function(e:MouseEvent):void
 			{
				if (_enabled)
				{
					setDrawMode();
					if (_scrollProperty == "_color")
			 			hideAll();
			 		else
			 			activateColorControl();
			 	}
			}

 			_content.colorButton.addEventListener(MouseEvent.CLICK, clickHandler) 
 			_content.colorPicker.buttonMode = true;
 		}

 		private function refreshColor(e:MouseEvent):void
 		{
 			var oldColor:int = _color;
 			_color = selectedColor;
 			refresh();
 			_color = oldColor;
 		}
 		
 		private function applyColor(e:MouseEvent):void
 		{
 			_color = selectedColor;
 			hideAll();
 			refresh();
 		}
 		
 		private function get selectedColor():int
 		{
 			return GraphUtils.getPixel(_content.colorPicker,
 				_content.colorPicker.mouseX,
 				_content.colorPicker.mouseY
 			)
 		}
 		
 		private function activateColorControl():void
 		{
 			hideAll();
 			_scrollProperty = "_color";
			_content.colorPicker.visible = true;
			_content.nextButton.visible = true;
			_content.background.gotoAndStop(1);
 		}
 		
 		private function initScrollControl(button:DisplayObject, propertyName:String, frameNum:int):void
 		{
 			var wheelHandler:Function = function (e:MouseEvent):void
 			{
 					_scroller.position += (e.delta > 0) ? 0.1 : -0.1;
 			}
 			
 			var clickHandler:Function = function (e:MouseEvent):void
 			{
 				if (_enabled)
 				{
					setDrawMode();
 					if (_scrollProperty == propertyName)
 						hideAll();
 					else
		 				activateScrollControl(button, propertyName, frameNum);
		 		}
 			} 
 			 
 			button.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
 			button.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
 		}
 		
 		private function activateScrollControl(button:DisplayObject, propertyName:String, frameNum:int):void
 		{
 			hideAll();
 			_content.scroller.visible = true;
 			_scrollProperty = propertyName;
 			_scroller.position = this[_scrollProperty];
 			_content.scroller.y = button.y + 0.5 * button.height + _content.scroller.height * 2; 
 			_content.background.gotoAndStop(frameNum);
 		}
 		
 		private function onScrollerChange(sender:Scroller):void
 		{
 			if (_content.scroller.visible)
 			{
 				this[_scrollProperty] = _scroller.position;
 				refresh();
 			}
 		}
 		
 		private function refresh(param:Object = null):void
 		{
 			var rgb:Object = GraphUtils.toRGB(_color);
 			var clip:Sprite = _content.sample;
 			
 			clip.transform.colorTransform = 
 				new ColorTransform(rgb.r / 255.0, rgb.g / 255.0, rgb.b / 255.0, 1 - _alpha);
 				
 			clip.scaleX = clip.scaleY = 0.1 + 0.9 * _size;
 			
 			clip.filters = [
 				new BlurFilter(_defaultSize * _blur, _defaultSize * _blur)
 			];
 		}
 		
		public function hideAll():void
		{
			_scrollProperty = null;
			_content.background.gotoAndStop(1);
			_content.scroller.visible = false;
			_content.colorPicker.visible = false;
			_content.nextButton.visible = false;
		}
		
		public function get lineInfo():LineInfo
		{
			 var info:LineInfo = new LineInfo();
			 info.color = _color;
			 info.size = _size;
			 info.alpha = 1 - _alpha;
			 info.blur = _blur;
			 
			 return info;
		}
		
		public function get modeChangeEvent():EventSender { return _modeChangeEvent; }
	}
}
