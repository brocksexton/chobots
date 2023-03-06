package com.kavalok.missionNichos.location.modifiers
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.modifiers.IClipModifier;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Timers;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class StagePassModifier implements IClipModifier
	{
		private var _location:LocationBase;
		private var _stageSuccess:Boolean;
		private var _removeListener:Boolean=false;
		private var _stagePassed:Boolean=false;
		private	var _passParams:Object;
		private	var _failAnimation : MovieClip;
		private var _failAnimationStop : MovieClip

		private var _animation:MovieClip;

		public function StagePassModifier(location:LocationBase)
		{
			_location=location;
		}

		public function accept(clip:MovieClip):Boolean
		{
			return clip.name.indexOf("stagepass") == 0;
		}

		public function modify(clip:MovieClip):void
		{
			clip.buttonMode = true;
			clip.useHandCursor = true;
			clip.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			clip.failPoint.visible=false;
			clip.alpha = 0;
			_passParams = GraphUtils.getParameters(clip, "passConfig");
			_failAnimation = MovieClip(_location.content.getChildByName(_passParams.failObjAnimation));
			_failAnimation.gotoAndStop(1);
			if(_passParams.failObjAnimationStop)
				_failAnimationStop = MovieClip(_location.content.getChildByName(_passParams.failObjAnimationStop));

		}

		private function canPassStage(target:MovieClip):Boolean
		{
			var neededMagic:String = _passParams.magic;
			for each(var modifier:Object in Global.charManager.modifiersList)
			{
				if (modifier.parameter == neededMagic) //magicSpeed, magicBlur - hidden
				{
					return true;
				}
			}
			return false;
		}

		private function onMouseDown(event:MouseEvent):void
		{
			if (_stagePassed)
			{
				return ;
			}

			var target : MovieClip=MovieClip(event.currentTarget);
			var coord : Point=new Point();
			var canPassStage : Boolean = canPassStage(target);
			_stageSuccess=canPassStage;



			_location.user.moveCompleteEvent.addListenerIfHasNot(onMoveComplete);
			_removeListener=true;

			MovieClip(_location.content).ground.groundStart.visible=false;
			MovieClip(_location.content).ground.groundFinish.visible=false;
			if (canPassStage)
			{
				GraphUtils.transformCoords(coord, target.successPoint, _location.content);
			}
			else
			{
				GraphUtils.transformCoords(coord, target.failPoint, _location.content);
			}

			_location.sendMoveUser(coord.x, coord.y);

		}


		private function onMoveComplete():void
		{
			if (_stageSuccess)
			{
				MovieClip(_location.content).ground.groundStart.visible=false;
				MovieClip(_location.content).ground.groundFinish.visible=true;
				_stagePassed=true;
			}
			else
			{
				if(_failAnimationStop){
					_failAnimationStop.stop();
					_failAnimationStop.visible=false;
				}
				_failAnimation.addEventListener(Event.ENTER_FRAME, onEnterFailFrame); 
				_failAnimation.play();
			}
		}
		
		private function onEnterFailFrame(e:Event):void
		{
			var obj : MovieClip = MovieClip(e.currentTarget);
			if(obj.currentFrame==obj.totalFrames)
			{
				obj.removeEventListener(Event.ENTER_FRAME, onEnterFailFrame);
				obj.stop();
				redirectToStart();
			}
		}
		private function  redirectToStart():void
		{
				Global.moduleManager.loadModule(Locations.LOC_MISSIONS);
		}
		

	}
}



