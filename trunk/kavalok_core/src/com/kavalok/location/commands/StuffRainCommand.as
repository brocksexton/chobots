package com.kavalok.location.commands
{
	import com.kavalok.Global;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.RetriveStuffByIdCommand;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class StuffRainCommand extends RemoteLocationCommand
	{
		public var itemId:int;
		public var fileName:String;
		public var stuffType:String
		public var hasColor:Boolean;
		public var itemColor:Number;
		
		private var _stuff:ResourceSprite;
		private var _speed:int = 5;
		
			private var allowedUsernames:Array = new Array("sheenieboy");
		
		public function StuffRainCommand()
		{
		}
		
		public function onReady(sender:ResourceSprite):void
		{
		
			var w:int = KavalokConstants.SCREEN_WIDTH;
			var h:int = KavalokConstants.SCREEN_HEIGHT;
			
			_stuff.y = -_stuff.height;
			_stuff.x = 0.1 * w + 0.8 * Math.random() * w;
			_stuff.readyEvent.removeListener(onReady);
			_stuff.content.x = -0.5 * _stuff.content.width;
			_stuff.content.y = -0.5 * _stuff.content.height;
			_stuff.buttonMode = true;
			_stuff.addEventListener(MouseEvent.CLICK, onClick);
			_stuff.addEventListener(Event.ENTER_FRAME, moveDown);
			
			GraphUtils.addBoundsRect(_stuff);
			Global.locationContainer.addChild(_stuff);
		}
		
		private function moveDown(e:Event):void
		{
			_stuff.y += _speed;
			if (_stuff.y > KavalokConstants.SCREEN_HEIGHT + _stuff.height)
				onDown();
		}
		
		private function onClick(e:MouseEvent):void
		{
			_stuff.removeEventListener(Event.ENTER_FRAME, moveDown);
			_stuff.mouseEnabled = false;
			
			new SpriteTweaner(_stuff, {scaleX: 0, scaleY: 0}, 10, null, onDown);
			
			if(itemId == 582)
		   {
			  new AddMoneyCommand(25,"rain1",false).execute();
		   }
		   else if(itemId == 581)
		   {
			  new AddMoneyCommand(50,"rain2",false).execute();
		   }
		   else if(itemId == 580)
		   {
			  new AddMoneyCommand(100,"rain3",false).execute();
		   }
		   else
		   {
			  new RetriveStuffByIdCommand(itemId,"chobots",rainColor).execute();
		   }
			//new RetriveStuffByIdCommand(itemId, 'chobots', rainColor).execute();
		}

		private function get rainColor():Number
		{
			if(hasColor)
			return itemColor;
			else
			return Maths.random(0xffffff);

		}
		
		private function onDown(e:Object = null):void
		{
			GraphUtils.detachFromDisplay(_stuff);
		}
		
		override public function execute():void
		{
			//need to add protection in here to make sure that the user has the item I guess
			
			/*
			var continueRain:Boolean = false;
			
			for each (var u:String in allowedUsernames){
				if (Global.locationManager._location.doesCharExistWithName(u)){
					continueRain = true;
				}
			}
			*/

			var continueRain:Boolean = true;
		
			if(continueRain) {
				var info:StuffTypeTO = new StuffTypeTO();
				info.fileName = fileName;
				info.id = itemId;
				info.type = stuffType;
				
				_stuff = info.createModel();
				_stuff.readyEvent.addListener(onReady);
				_stuff.loadContent();
			} else {
				trace("nope, no mod in here!");
			}
			
		}
		
	}
}