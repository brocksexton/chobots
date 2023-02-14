package com.kavalok.gameplay
{
	import com.gskinner.geom.ColorMatrix;
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.RectangleSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteDecorator;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	public class ResourceSprite extends Sprite
	{
		public static const CONTROL_POINT : String = "controlPoint";
		
		public var fitToBounds:Boolean = true;
		public var boundsMargin:Number = 0;

		private var _className:String;
		private var _url:String;
		private var _loaderView:RectangleSprite;
		
		private var _readyEvent:EventSender = new EventSender();
		private var _content:DisplayObject;
		private var _gray:Boolean;
		private var _useView:Boolean;
		private var _background:DisplayObject;
		
		public function ResourceSprite(url:String, className:String,
			autoLoad:Boolean = true, useView:Boolean = true)
		{
			super();
			
			_url = url;
			_className = className;
			_useView = useView;
			
			createView();
			
			if (!_useView)
				_loaderView.visible = false;
			
			if (autoLoad)
				loadContent();
		}
		
		public function loadContent():void
		{
			Global.classLibrary.callbackOnReady(onClassReady, [_url]);
		}
		
		public function destroy():void
		{
			_readyEvent.removeListeners();
		}
		
		private function createView():void
		{
			_loaderView = new RectangleSprite(50, 50);
			_loaderView.suspendLayout();
			_loaderView.backgroundColor = 0;
			_loaderView.backgroundAlpha = 0.1;
			_loaderView.borderColor = 0;
			_loaderView.borderAlpha = 0.2;
			_loaderView.cornerRadius = 7;
			_loaderView.resumeLayout();
			
			addChild(_loaderView);
		}
		
		private function onClassReady():void
		{
			addEventListener(Event.ENTER_FRAME, constructSprite);
		}
		
		private function constructSprite(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, constructSprite);
			
			_content = Global.classLibrary.getInstance(_url, _className) as DisplayObject;
			GraphUtils.attachAfter(_content, _loaderView);
			
			if(_content is MovieClip)
				MovieClip(_content).gotoAndStop(1);
				
			if(_content is DisplayObjectContainer)
			{
				GraphUtils.hideConfigs(_content as DisplayObjectContainer);//to make config invisible
				DisplayObjectContainer(_content).mouseChildren = false;
			}
				
			if (fitToBounds)
				adjustPosition();
			
			removeChild(_loaderView);
			_loaderView = null;
			
			if(_gray)
				makeGray();
			
			_readyEvent.sendEvent(this);
		}
		
		private function adjustPosition():void
		{
			var boundsSprite:DisplayObject = _background || _loaderView;
			var bounds:Rectangle = boundsSprite.getRect(this);
			bounds.left += boundsMargin;
			bounds.top += boundsMargin;
			bounds.right -= boundsMargin;
			bounds.bottom -= boundsMargin;
			
			GraphUtils.fitToBounds(_content, bounds);
		}
		
		public function makeGray() : void
		{
			_gray = true;
			if(_content)
			{
				SpriteDecorator.decorateColor(Sprite(_content), 0x888888, 0x575757);
				
				var matrix:ColorMatrix = new ColorMatrix();
				matrix.adjustSaturation(-100);
				_content.filters = [new ColorMatrixFilter(matrix)];
				var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 35, 25 , 0);
				_content.transform.colorTransform = colorTransform;
			}
		}
		
		public function set useView(value:Boolean):void
		{
			 _useView = value;
			 if (!_useView && _loaderView)
			 	_loaderView.visible = false;
		}
		
		public function set background(value:DisplayObject):void
		{
			 if (_background)
			 	GraphUtils.detachFromDisplay(_background);
			 
			 _background = value;
			 
			 if (_background)
			 {
			 	addChildAt(_background, 0);
			 	if (_loaderView)
			 	{
			 		_loaderView.width = background.width;
			 		_loaderView.height = background.width;
			 	}
			 }
		}
		
		public function get background():DisplayObject
		{
			 return _background;
		}
		
		public function get readyEvent():EventSender { return _readyEvent; }
		public function get content():DisplayObject { return _content; }
		public function get loaderView():Sprite { return _loaderView; }
		
	}
}