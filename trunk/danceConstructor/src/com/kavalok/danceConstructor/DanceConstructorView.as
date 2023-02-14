package com.kavalok.danceConstructor
{
	import com.kavalok.char.CharModel;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.Directions;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.constants.Modules;
	import com.kavalok.dance.BoneParts;
	import com.kavalok.dance.BonePlayer;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.layout.TileLayout;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.comparing.ClassRequirement;
	import com.kavalok.utils.converting.ToPropertyValueConverter;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class DanceConstructorView extends BoneModelViewBase
	{
		private var MAX_FRAMES_COUNT:int=9;
		private var MAX_ROW_ITEMS:int=3;
		private var CLICKS_TO_REMOVE_TIP:int=2;

		private var _content:McBackground;
		private var _framesLayout:TileLayout;
		private var _frameViews:ArrayList=new ArrayList();
		private var _currentFrame:FrameView;
		private var _player:BonePlayer;
		private var _tipClicks:int=0;

		public function DanceConstructorView(charInfo:Object, content:McBackground)
		{
			_content=content;
			new ResourceScanner().apply(content);
			GraphUtils.removeAllChildren(_content.frames);
			_framesLayout=new TileLayout(_content.frames);
			_framesLayout.direction = TileLayout.HORIZONTAL;
			_framesLayout.maxItems = MAX_ROW_ITEMS;
			_framesLayout.distance = 2;
			super(_content, charInfo);
			_content.playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
		}

		public function set frames(value:Array):void
		{
			_frameViews=new ArrayList();
			GraphUtils.removeAllChildren(_content.frames, new ClassRequirement(McFrame));
			for each (var coords:Object in value)
				addFrame(coords);
				
			FrameView(_frameViews.first).closeEnabled=false;
			updatePlusVisible();

		}

		public function get finalFrames():Array
		{
			var result : Array = frames;
			var model : CharModel = new CharModel();
			model.setModel(CharModels.STAY, Directions.DOWN);
			result.unshift(new BoneParts(model.content).coords);
			result.push(new BoneParts(model.content).coords);
			return result;
		}
		public function get frames():Array
		{
			return Arrays.getConverted(_frameViews, new ToPropertyValueConverter("coords"));
		}

		override protected function onModelReady():void
		{
			super.onModelReady();
			_player=new BonePlayer(bone, _content);
			bone.changeEvent.addListener(onBoneChange);
			addFrame();
			
			addTip(bone.body.skin);
			addTip(bone.head.skin);
			addTip(bone.leftHandBottom.skin);
			addTip(bone.leftHandTop.skin);
			addTip(bone.leftLeg.skin);
			addTip(bone.neck.skin);
			addTip(bone.pimpa.skin);
			addTip(bone.rightHandBottom.skin);
			addTip(bone.rightHandTop.skin);
			addTip(bone.rightLeg.skin);
			_currentFrame.closeEnabled=false;
		}

		private function addTip(clip : MovieClip):void
		{
			clip.useHandCursor = true;
			clip.mouseChildren = false;
			clip.buttonMode = true;
			ToolTips.registerObject(clip, "tryToDrag", Modules.DANCE_CONSTRUCTOR);
			clip.addEventListener(MouseEvent.MOUSE_DOWN, onPartMouseDown);
		}
		private function onPartMouseDown(event : MouseEvent):void
		{
			_tipClicks++;
			if(_tipClicks > CLICKS_TO_REMOVE_TIP)
			{
				ToolTips.unRegisterObject(bone.body.skin);
				ToolTips.unRegisterObject(bone.head.skin);
				ToolTips.unRegisterObject(bone.leftHandBottom.skin);
				ToolTips.unRegisterObject(bone.leftHandTop.skin);
				ToolTips.unRegisterObject(bone.leftLeg.skin);
				ToolTips.unRegisterObject(bone.neck.skin);
				ToolTips.unRegisterObject(bone.pimpa.skin);
				ToolTips.unRegisterObject(bone.rightHandBottom.skin);
				ToolTips.unRegisterObject(bone.rightHandTop.skin);
				ToolTips.unRegisterObject(bone.rightLeg.skin);
			}
		}
		private function onBoneChange():void
		{
			_currentFrame.coords=bone.coords;
		}

		private function addFrame(coords:Object=null, index : int = -1):void
		{
			var frame:FrameView=new FrameView(charInfo);
			
			_content.frames.addChild(frame.content);
			if(index != -1)
				_content.frames.setChildIndex(frame.content, index);
			
			_framesLayout.apply();
			frame.selectEvent.addListener(onFrameSelect);
			frame.removeEvent.addListener(onFrameRemove);
			frame.addEvent.addListener(onFrameAdd);
			_currentFrame=frame;
			_currentFrame.coords=coords || bone.coords;
			_frameViews.addItemAt(index, frame);
			
			updatePlusVisible();
			updateMinusVisible();
			updateSelected();
		}

		private function updateMinusVisible():void
		{
			for each(var view : FrameView in _frameViews)
				view.closeEnabled = _frameViews.length > 1;
		}
		private function updatePlusVisible():void
		{
			for each(var view : FrameView in _frameViews)
				view.plusVisible = _frameViews.length < MAX_FRAMES_COUNT;
		}

		private function onPlayClick(event:MouseEvent):void
		{
			_player.play(frames);
		}

		private function onFrameRemove(frame:FrameView):void
		{
			_frameViews.removeItem(frame);
			frame.selectEvent.removeListener(onFrameSelect);
			frame.removeEvent.removeListener(onFrameRemove);
			frame.addEvent.removeListener(onFrameAdd);
			_content.frames.removeChild(frame.content);
			_framesLayout.apply()
			if (_currentFrame == frame)
				onFrameSelect(_frameViews.first);
			updatePlusVisible();
			updateMinusVisible();
		}

		private function onFrameAdd(frame:FrameView):void
		{
			var index : int = _frameViews.indexOf(frame);
			addFrame(frame.cloneCoords(), index + 1);
		}

		private function onFrameSelect(frame:FrameView):void
		{
			bone.coords=frame.coords;
			_currentFrame=frame;
			updateSelected();
		}
		private function updateSelected():void
		{
			for each(var frame : FrameView in _frameViews)
			{
				if(_currentFrame != frame)
				{
					GraphUtils.makeGray(frame.content);
				}
				else
				{
					frame.content.filters = [];
				}
				
			}
		}

	}
}