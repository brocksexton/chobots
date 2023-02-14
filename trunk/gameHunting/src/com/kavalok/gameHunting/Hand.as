package com.kavalok.gameHunting
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameHunting.McHandClip;
	import gs.easing.Elastic;
	import gs.TweenLite;
	
	public class Hand
	{
		static private const MODEL_Y:int = 100;
		
		
		private var _content:McHandClip;
		private var _bounds:Rectangle;
		private var _item:Sprite;
		private var _model:Sprite;
		private var _ready:Boolean = true;
		private var _shellName:String;
		private var _shellInfo:ShellInfo;
		
		public function Hand(content:McHandClip)
		{
			_content = content;
			
			_bounds = _content.handArea.getBounds(_content);
			
			_item = new Sprite();
			_item.y = _content.handArea.y + 0.5 * _content.handArea.height;
			_item.buttonMode = true;
			_content.addChild(_item);
			GraphUtils.detachFromDisplay(_content.handArea);
		}
		
		public function setModel(shellName:String):void
		{
			_shellName = shellName;
			if (!_model)
				createModel();
		}
		
		public function createModel():void
		{
			_ready = false;
			
			if (_model)
				GraphUtils.detachFromDisplay(_model);
			
			_shellInfo = ShellFactory.shells[_shellName];
			var shellClass:Class = _shellInfo.classSpriteIn;
			_model = new shellClass();
			_model.cacheAsBitmap = true;
			_item.addChild(_model);
			GraphUtils.stopAllChildren(_model);
			showModel();
		}
		
		private function showModel():void
		{
			_model.y = MODEL_Y;
			_model.cacheAsBitmap = true;
			var showProps:Object =
			{
				y : 0,
				ease: Elastic.easeInOut,
				onComplete: onModelShow,
				onCompleteParams: [_model]
			}
			TweenLite.to(_model, _shellInfo.showTime, showProps);
		}
		
		private function onModelShow(model:Sprite):void
		{
			_ready = true;
		}
		
		public function setPosition(x:int):void
		{
			_item.x = x;
			if (_item.x - 0.5 * _item.width < _bounds.left)
				_item.x = _bounds.left + 0.5 * _item.width;
			else if (_item.x + 0.5 * _item.width > _bounds.right)
				_item.x = _bounds.right - 0.5 * _item.width;
		}
		
		public function get position():Number
		{
			return (_item.x - _bounds.left) / _bounds.width;
		}
		
		public function get content():McHandClip { return _content; }
		
		public function get item():Sprite { return _item; }
		
		public function get shellInfo():ShellInfo { return _shellInfo; }
		
		public function get shellName():String { return _shellName; }
		
		public function get ready():Boolean { return _ready; }
		
	}
	
}