package com.kavalok.robots
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.NameRequirement;
	import com.kavalok.utils.SpriteDecorator;
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;

	public class RobotModel extends Sprite
	{
		private var _robot:Robot;
		
		private var _readyEvent:EventSender = new EventSender();
		
		private var _content:MovieClip;
		private var _modelName:String = RobotModels.DEFAULT;
		private var _assets:Array;
		private var _assetsLoaded:Boolean = false;
		private var _interactive:Boolean = false;
		
		public function RobotModel(robot:Robot)
		{
			_robot = robot;
			super();
		}
		
		public function set robot(value:Robot):void
		{
			 _robot = value;
			 _assetsLoaded = false;
			 updateModel();
		}
		
		public function setModel(modelName:String):void
		{
			_modelName = modelName;
			updateModel();
		}
		
		public function updateModel():void
		{
			if (_assetsLoaded)
				createModel();
			else
				loadAssets();			
		}
		
		private function loadAssets():void
		{
			var urlList:Array = [];
			
			for each (var item:RobotItemTO in _robot.items)
			{
				urlList.push(URLHelper.robotItemURL(item.name));
			}
			
			if (urlList.length > 0)
				Global.classLibrary.callbackOnReady(onAssetsLoaded, urlList);
		}
		
		private function onAssetsLoaded():void
		{
			_assets = [];
			
			for each (var item:RobotItemTO in _robot.items)
			{
				var url:String = URLHelper.robotItemURL(item.name);
				_assets.push(
					{
						domain: Global.classLibrary.getDomain(url),
						color: item.color
					}
				);
			}
			
			createModel();
			
			_assetsLoaded = true;
			_readyEvent.sendEvent();
		}
		
		private function createModel():void
		{
			destroy();
			
			var className:String = _modelName;
			
			var modelURL:String = URLHelper.getRobotModelURL(_robot.name);
			_content = MovieClip(Global.classLibrary.getInstance(modelURL, className));
			_content.addEventListener(Event.CHANGE, onChangeInAnim);
			decorateModel();
			updateInteractive();
			
			addChild(_content);
		}
		
		private function onChangeInAnim(e:Event):void
		{
			decorateModel();
		}
		
		private function decorateModel():void
		{
			var colorInfo:Object = GraphUtils.toRGB(_robot.bodyItem.color);
			var sprites:Array = GraphUtils.getAllChildren(_content, new TypeRequirement(Sprite), false);
			for each (var sprite:Sprite in sprites)
			{
				if (sprite.name.indexOf('_Ch') != 0) {
					var children:Array = GraphUtils.getAllChildren(sprite, new TypeRequirement(DisplayObject), false);
					for each (var child:DisplayObject in children)
					{
						child.transform.colorTransform = new ColorTransform(
							colorInfo.r/255.0, colorInfo.g/255.0, colorInfo.b/255.0);
					}
				}
			}
			
			SpriteDecorator.decorateModel(_content, _assets, true, true);
		}
		
		public function set scale(value:Number):void
		{
			scaleX = scaleY = value;
		}
		
		public function destroy():void
		{
			if (_content)
			{
				removeChild(_content);
				_content.stop();
				_content = null;
			}
		}
		
		public function getItemSprites(item:RobotItemTO):Array
		{
			var spriteNames:Object = {};
			spriteNames[RobotTypes.HEAD] = '_ChHead';
			spriteNames[RobotTypes.SHIELD] = '_ChShield';
			spriteNames[RobotTypes.RACK] = '_ChRack';
			spriteNames[RobotTypes.WEAPON] = '_ChWeapon';
			
			var partName:String = spriteNames[item.placement];
			
			if (partName)
				return GraphUtils.getAllChildren(_content, new NameRequirement(partName));
			else
				return [];
		}
		
		private function updateInteractive():void
		{
			if (_content)
			{
				_content.mouseEnabled = _interactive;
				_content.mouseChildren = interactive;
			}
		}
		
		public function get interactive():Boolean { return _interactive; }
		public function set interactive(value:Boolean):void
		{
			 _interactive = value;
			 updateInteractive();
		}
		
		public function get ready():Boolean
		{
			 return _assetsLoaded;
		}
				
		public function get readyEvent():EventSender { return _readyEvent; }
		
		public function get robot():Robot { return _robot; }
		
		public function get modelName():String { return _modelName; }
		
		public function get content():MovieClip { return _content };
		
	}
}