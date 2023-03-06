package com.kavalok.missionNichos
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.location.LocationBase;
	import com.kavalok.missionNichos.location.modifiers.StagePassModifier;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Timers;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class NichosStageBase extends LocationBase
	{

		private static var ENABLE_DARKNESS : Boolean = true;

		private var _location:MovieClip;
		private var _columnsPassModifier:StagePassModifier;
		private var _maskContainer:MovieClip;
		protected var _blurContainer:MovieClip;
		private var _hasLight:Boolean;

		public function NichosStageBase(locId:String, remoteId:String, locationContent : MovieClip)
		{
			var backGround:Sprite=new Sprite();
			backGround.graphics.beginFill(0);
			backGround.graphics.drawRect(0, 0, KavalokConstants.SCREEN_WIDTH, KavalokConstants.SCREEN_HEIGHT);
			backGround.graphics.endFill();
			Global.root.addChildAt(backGround, 0);

			super(locId, remoteId);
			_location=locationContent;
			setContent(_location);

			_hasLight = hasLight();

			addModifier(new StagePassModifier(this));


			_location.ground.groundStart.visible=true;
			_location.ground.groundFinish.visible=false;


			_maskContainer=new McShadowMask();
			
			
			//this.content.cacheAsBitmap = true;
			_maskContainer.cacheAsBitmap = true;
			

			_blurContainer=new McShadow();
			_blurContainer.cacheAsBitmap = true;


			if(ENABLE_DARKNESS){
				Global.root.addChild(_maskContainer);
				this.content.mask=_maskContainer;
				this.content.addChild(_blurContainer);
			}

			if(_hasLight){
				if(ENABLE_DARKNESS){
				}
			}else{
				if(ENABLE_DARKNESS){
					_blurContainer.width=0;
					_blurContainer.height=0;
					_maskContainer.width=0;
					_maskContainer.height=0;
				}
			}


			this.userAdded.addListener(onUserAdded);
		}

		private function onUserAdded(event:LocationChar):void
		{
			this.user.content.addEventListener(Event.ENTER_FRAME, onUserEnterFrame);
		}

		private function onUserEnterFrame(e:Event):void
		{
			var coord : Point=new Point();
			GraphUtils.transformCoords(coord, this.user.content, this.content);

			if(_hasLight){
				if(ENABLE_DARKNESS){
					this.content.mask.x=coord.x;
					this.content.mask.y=coord.y - 25;
	
					_blurContainer.x=coord.x;
					_blurContainer.y=coord.y - 25;
				}
			}
		}
		
		protected function hasLight():Boolean
		{
			for each(var cloth : StuffItemLightTO in Global.charManager.stuffs.getUsedClothes())
			{
				if (cloth.fileName == 'lampochka')
				{
					return true;
				}
			}
			return false;
		}
		
		protected function disableDarkness():void{
			if(ENABLE_DARKNESS){
				_location.ground.groundStart.visible=true;
				ENABLE_DARKNESS = false;
				this.content.mask=null;
				Global.root.removeChild(_maskContainer);
				this.content.removeChild(_blurContainer);
			}

		}
		


	}

}













