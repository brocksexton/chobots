package
{
	import common.comparing.PropertyRequirement;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import common.utils.GraphUtil;
	import flash.media.SoundTransform;
	import gs.TweenLite;
	import gs.easing.*;
	
	public class AnimBase extends MovieClip
	{
		private var _content:MovieClip;
		private var _bitmap:Bitmap;
		private var _animations:Array = [];
		private var _currentIndex:int = 0;
		private var _overClip:MovieClip;
		
		public function AnimBase():void
		{
			_content = this.getChildAt(1) as MovieClip;
			_content.visible = false;
			
			initAnimations();
			
			if (this.stage)
				initialize();
			else
				this.addEventListener(Event.ADDED_TO_STAGE, initialize);
				
			this.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		private function initAnimations():void
		{
			_animations = GraphUtil.getChildren(_content,
				new PropertyRequirement('name', 'animationClip'));
				
			for each (var clip:MovieClip in _animations)
			{
				GraphUtil.stopAllChildren(clip);
				GraphUtil.addBoundsRect(clip);
				clip.mouseChildren = false;
				clip.addEventListener(MouseEvent.MOUSE_OVER, onClipOver);
				clip.addEventListener(MouseEvent.MOUSE_OUT, onClipOut);
				clip.buttonMode = true;
				clip.soundTransform = new SoundTransform(0);
			}
		}
		
		private function onClipOut(e:MouseEvent):void
		{
			_overClip.gotoAndStop(_overClip.totalFrames);
			_overClip.soundTransform = new SoundTransform(0);
			_overClip = null;
		}
		
		private function onClipOver(e:MouseEvent):void
		{
			_overClip = e.currentTarget as MovieClip;
			_overClip.soundTransform = new SoundTransform(0.5);
			
			var clipIndex:int = _animations.indexOf(_overClip);
			
			if (clipIndex != _currentIndex)
			{
				_currentIndex = clipIndex;
				GraphUtil.playAllChildren(currentClip);
				_overClip.gotoAndStop(1);
			}
		}
		
		public function get currentClip():MovieClip
		{
			return _animations[_currentIndex];
		}
		
		private function onComplete():void
		{
			this.removeChild(_bitmap);
			_bitmap = null;
			_content.visible = true;
			_content.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void
		{
			var clip:MovieClip = _animations[_currentIndex];
			if (clip.currentFrame == clip.totalFrames)
			{
				clip.gotoAndStop(1);
				GraphUtil.stopAllChildren(clip);
				
				if (!_overClip)
				{
					_currentIndex++;
					if (_currentIndex == _animations.length)
					{
						_currentIndex = 0;
						GraphUtil.playAllChildren(currentClip);
						currentClip.gotoAndStop(1);
					}
				}
			}
			else
			{
				clip.nextFrame();
			}
		}
		
		
		private function initialize(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			createBitmap();
			TweenLite.to(_bitmap, 2, { alpha: 1, onComplete: onComplete, ease: Quad.easeOut } );
		}
		
		private function createBitmap():void
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(_content.x, _content.y);
			var bitmapData:BitmapData = new BitmapData(
				stage.stageWidth, stage.stageHeight, false, 0xFFFFFF);
			bitmapData.draw(_content, matrix);
			_bitmap = new Bitmap(bitmapData);
			_bitmap.alpha = 0;
			this.addChild(_bitmap);
		}
		
		private function dispose(e:Event = null):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
	}
}