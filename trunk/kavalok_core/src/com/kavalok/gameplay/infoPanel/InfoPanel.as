package com.kavalok.gameplay.infoPanel
{
	import com.kavalok.gameplay.StarField;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	
	import core.McStar;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class InfoPanel extends ClientBase
	{
		static public const PREFIX:String = 'info_panel';
		static public const PANEL_ID:String = 'infoPanel'
		static public const DATA_STATE:String = 'dataState'
		static public const STARS_SPEED:int = 3;
		
		private var _display:Sprite;
		private var _mask:DisplayObject;
		private var _content:InfoContent;
		private var _stars:StarField;
		private var _contentData:XML;
		
		public function InfoPanel(display:Sprite)
		{
			_display = display;
			_mask = _display.getChildAt(0);
			_display.mask = _mask;
			
			createStars();
			GraphUtils.roundCoords(_display);
			
			connectEvent.addListener(onConnect);
			connect(PANEL_ID);
		}
		
		override public function get id():String
		{
			return PANEL_ID;
		}
		
		private function onConnect():void
		{
			if (DATA_STATE in states)
				rInfoData(DATA_STATE, states[DATA_STATE]);
		}
		
		public function rInfoData(stateId:String, state:Object, dammy:Boolean = false):void
		{
			trace('newContent')
			_contentData = new XML(state.data);
			if (!_content)
				createContent();
		}
		
		private function createContent():void
		{
			_content = new InfoContent(_contentData, _mask.getBounds(_display));
			_content.completeEvent.addListener(onContentComplete);
			_content.readyEvent.addListener(onContentReady);
			_content.alpha = 0;
			_contentData = null;
		}
		
		private function onContentReady():void
		{
			_display.addChild(_content);
			new SpriteTweaner(_content, {alpha: 1}, 10);
		}
		
		private function onContentComplete():void
		{
			new SpriteTweaner(_content, {alpha: 0}, 10, null, onShaderComplete);
		}
		
		private function onShaderComplete(sender:Sprite):void
		{
			GraphUtils.detachFromDisplay(_content);
			_content = null;
			
			if (_contentData)
				createContent();
		}
		
		private function createStars():void
		{
			_stars = new StarField(_mask.getBounds(_display));
			_stars.createStars(McStar, 30);
			
			_display.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_display.addEventListener(Event.REMOVED_FROM_STAGE, deactivate);
			
			_display.addChild(_stars.content);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_stars.move(-STARS_SPEED, 0);
		}
		
		private function deactivate(e:Event):void
		{
			_display.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_display.removeEventListener(Event.REMOVED_FROM_STAGE, deactivate);
			disconnect();
		}
	}
}