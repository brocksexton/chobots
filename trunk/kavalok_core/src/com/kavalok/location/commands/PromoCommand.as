package com.kavalok.location.commands
{
	import com.junkbyte.console.Cc;
	import com.kavalok.McFlyingPromo;
	import com.kavalok.McFlyingPromoSlendy;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	
	public class PromoCommand extends RemoteLocationCommand
	{
		public var text:String;
		public var Ptype:String;
		
		private var _original:McFlyingPromo;
		private var _slenderman:McFlyingPromoSlendy;
		private var _speed:Number = 2;
		
		public function PromoCommand()
		{
			super(); // i think this will fix this bitch.
		}
		
		override public function execute():void
		{
			Cc.info("promocommand executed...");
		     if(Ptype == "original"){
		      createContentOriginal();
				_original.addEventListener(Event.ENTER_FRAME, onEnterFrameOriginal);
		    }else if(Ptype == "slenderman"){
			  createContentSlenderman();
			  _slenderman.addEventListener(Event.ENTER_FRAME, onEnterFrameSlenderman);
			}
		}
		
		private function onEnterFrameOriginal(e:Event):void
		{
           
			_original.x -= _speed;
			_original.cacheAsBitmap = true;
			
			if (_original.x < -_original.width)
			{
				_original.removeEventListener(Event.ENTER_FRAME, onEnterFrameOriginal);
				GraphUtils.detachFromDisplay(_original);
			}
		}
		
		private function createContentOriginal():void
		{
			 _original = new McFlyingPromo();
			if(Ptype == "original")
			_original.gotoAndStop(1);
			if(Ptype == "yolo")
			_original.gotoAndStop(2);
			if(Ptype == "blackandwhite")
			_original.gotoAndStop(3);

			_original.promo.messageField.htmlText = text;
			_original.promo.messageField.width = _original.promo.messageField.textWidth + 10;
			_original.x = KavalokConstants.SCREEN_WIDTH;
			location.content.addChild(_original);
	
		}
		
		private function onEnterFrameSlenderman(e:Event):void
		{
           
			_slenderman.x -= _speed;
			_slenderman.cacheAsBitmap = true;
			
			if (_slenderman.x < -_slenderman.width)
			{
				_slenderman.removeEventListener(Event.ENTER_FRAME, onEnterFrameSlenderman);
				GraphUtils.detachFromDisplay(_slenderman);
			}
		}
		
		private function createContentSlenderman():void
		{
		   _slenderman = new McFlyingPromoSlendy();
			_slenderman.messageField.htmlText = text;
			_slenderman.messageField.width = _slenderman.messageField.textWidth + 10;
			_slenderman.x = KavalokConstants.SCREEN_WIDTH;
			location.content.addChild(_slenderman);
		}
	
	}
}