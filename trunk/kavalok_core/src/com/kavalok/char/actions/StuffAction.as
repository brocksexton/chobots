package com.kavalok.char.actions
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.char.modifiers.BevelModifier;
	import com.kavalok.char.modifiers.BigHeadModifier;
	import com.kavalok.char.modifiers.BlendModifier;
	import com.kavalok.char.modifiers.BlurModifier;
	import com.kavalok.char.modifiers.BoardModifier;
	import com.kavalok.char.modifiers.CharModifierBase;
	import com.kavalok.char.modifiers.FlameModifier;
	import com.kavalok.char.modifiers.FlyModifier;
	import com.kavalok.char.modifiers.GhostModifier;
	import com.kavalok.char.modifiers.HueModifier;
	import com.kavalok.char.modifiers.InvertModifier;
	import com.kavalok.char.modifiers.MoonwalkModifier;
	import com.kavalok.char.modifiers.PromoModifier;
	import com.kavalok.char.modifiers.RotModifier;
	import com.kavalok.char.modifiers.SaturationModifier;
	import com.kavalok.char.modifiers.Scale2Modifier;
	import com.kavalok.char.modifiers.ScaleModifier;
	import com.kavalok.char.modifiers.SmallHeadModifier;
	import com.kavalok.char.modifiers.SpeedModifier;
	import com.kavalok.char.modifiers.StuffModifier;
	import com.kavalok.char.modifiers.TeleportModifier;
	import com.kavalok.char.modifiers.ToxicModifier;
	import com.kavalok.char.modifiers.ToxicPink;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	public class StuffAction extends CharActionBase
	{
		static private const ANIMATION_CLASS:String = "McAnimation";
		
		private var _fileName:String;
		private var _animation:MovieClip;
		private var _modifiers:Object = 
		{
			magicSpeed	: SpeedModifier,
			magicBlur	: BlurModifier,
			magicScale	: ScaleModifier,
			magicStar	: StuffModifier,
			magicBubble	: StuffModifier,
			magicBubbleBlue	: StuffModifier,
			magicBubbleYellow : StuffModifier,
			magicBubbleGreen : StuffModifier,
			magicBubbleChobots : StuffModifier,
			magicBubbleDave : StuffModifier,
			magicbubbleheart : StuffModifier,
			magicKite : StuffModifier,
			magicBubbleBlack : StuffModifier,
			magicBalls	: StuffModifier,
			magicBottle	: RotModifier,
			magicCharly	: SaturationModifier,
			magicLarge	: Scale2Modifier,
			magicToxic	: ToxicModifier,
			magicBevel	: BevelModifier,
			magicHue	: HueModifier,
			magicFlame	: FlameModifier,
			magicGhost	: GhostModifier,
			magicBlend	: BlendModifier,
			magicInvert	: InvertModifier,
			magicUmnik	: BigHeadModifier,
			magicZhurdyai : SmallHeadModifier,
			magicTeleport : TeleportModifier,
			magicMoonwalk : MoonwalkModifier,
			magicPink : ToxicPink,
			magicPromotion : PromoModifier
		}
		
		override public function execute():void
		{
			_fileName = _parameters.fileName;
			Global.classLibrary.callbackOnReady(showAnimation, [url]);
		}
		
		protected function get url():String
		{
			return URLHelper.stuffURL(_fileName, StuffTypes.STUFF);			
		}
		
		protected function showAnimation():void
		{
			_animation = MovieClip(Global.classLibrary.getInstance(url, ANIMATION_CLASS));
			_char.content.addChild(_animation);
			_animation.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function removeAnimation():void
		{
			_char.content.removeChild(_animation);
			_animation.removeEventListener(Event.ENTER_FRAME, onFrame);
			_animation.stop();
			_animation = null;
		}
		
		private function onFrame(e:Event):void
		{
			if (_animation.currentFrame == _animation.totalFrames)
			{
				removeAnimation();
				onAnimationComplete();
			}
		}
		
		private function onAnimationComplete():void
		{
			var className:String = getQualifiedClassName(_modifiers[_fileName]);
			
			if (_char.isUser)
			{
				if (_fileName in _modifiers)
					Global.charManager.addModifier(className, _fileName);
				else if (_fileName == 'magicLantz')
					sendCircuit();
			}
			else
			{
				if (_fileName == 'magicNearest')
					expandModifier();
			} 
		}
		
		private function sendCircuit():void
		{
			var modifier:CharModifierBase = _char.lastModifier;
			if (modifier 
				&& !(modifier is FlyModifier)
				&& !(modifier is BoardModifier))
			{
				var parameters:Object = 
				{
					modifierClass: getQualifiedClassName(modifier),
					modifierParam: modifier.parameter
				}
				_location.sendUserAction(CircuitAction, parameters)
			}
			
		}
		
		private function expandModifier():void
		{
			var distance:Number = 100;
			if (GraphUtils.distance(_char.position, _location.user.position) < distance)
			{
				var modifier:CharModifierBase = _char.lastModifier;
				if (modifier 
					&& !(modifier is FlyModifier)
					&& !(modifier is BoardModifier))
				{
						Global.charManager.addModifier(getQualifiedClassName(modifier), modifier.parameter);

				}
			}					
		}
	}
}