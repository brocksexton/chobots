package com.kavalok.pets
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.char.Directions;
	import com.kavalok.dto.pet.PetTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.SpriteDecorator;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class PetModel extends Sprite
	{
		public var cacheEnabled:Boolean = true;
		
		private var _readyEvent:EventSender = new EventSender();
		
		private var _pet:PetTO;
		private var _content:MovieClip;
		private var _modelName:String = PetModels.STAY;
		private var _direction:int = Directions.DOWN;
		
		private var _assets:Array;
		private var _assetsLoaded:Boolean = false;
		private var _contentCache:Object = {};
		
		public function PetModel(pet:PetTO = null)
		{
			_pet = pet || new PetTO();
		}
		
		public function set pet(value:PetTO):void
		{
			 _pet = value;
			 _assetsLoaded = false;
			 _contentCache = [];
			 
			 updateModel();
		}
		
		public function setModel(modelName:String, direction:int = -1):void
		{
			_modelName = modelName;
			
			if (direction >= 0)
				_direction = direction;
				
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
			var itemNames:Array = _pet.items;
			
			for each (var itemName:String in itemNames)
			{
				if (itemName)
					urlList.push(URLHelper.petItemURL(itemName));
			}
			
			if (urlList.length > 0)
				Global.classLibrary.callbackOnReady(onAssetsLoaded, urlList);
		}
		
		private function onAssetsLoaded():void
		{
			_assets = [];
			
			var itemNames:Array = _pet.items;
			var colors:Array = _pet.colors;
			
			for (var i:int = 0; i < itemNames.length; i++)
			{
				var url:String = URLHelper.petItemURL(itemNames[i]);
				
				_assets.push(
					{
						domain: Global.classLibrary.getDomain(url),
						color: colors[i]
					}
				);
			}
			
			createModel();
			
			_assetsLoaded = true;
			_readyEvent.sendEvent();
		}
		
		public function set scale(value:Number):void
		{
			scaleX = scaleY = value;
		}
		
		
		private function createModel():void
		{
			destroy();
			
			var className:String = _modelName;
			
			if (_modelName == PetModels.STAY || _modelName == PetModels.WALK)
			{
				var direction:int = _direction; 
				if (direction == Directions.LEFT_DOWN)
					direction = Directions.RIGHT_DOWN;
				else if (direction == Directions.LEFT) 
					direction = Directions.RIGHT;
				if (direction == Directions.LEFT_UP)
					direction = Directions.RIGHT_UP;
					
				if (direction >= 0)
					className += direction;
			}
			
			if (className in _contentCache)
			{
				_content = _contentCache[className];
				_content.gotoAndPlay(1);
			}
			else
			{
				_content = MovieClip(Global.classLibrary.getInstance(URLHelper.petModels, className));
				_content.mouseEnabled = false;
				_content.mouseChildren = false;
				_content.addEventListener(Event.CHANGE, onChangeInAnim);
				decorateModel();
				
				if (cacheEnabled)
					_contentCache[className] = _content;
			}
			
			addChild(_content);
			
			_content.scaleX = (direction == _direction) ? 1 : -1;
		}
		
		private function onChangeInAnim(e:Event):void
		{
			decorateModel();
		}
		
		private function decorateModel():void
		{
			SpriteDecorator.decorateModel(_content, _assets, true, true);
		}
		
		
		public function rotateLeft():void
		{
			var direction:int = (_direction == 7) ? 0 : _direction + 1;
			setModel(_modelName, direction); 
		}
		
		public function rotateRight():void
		{
			var direction:int = (_direction == 0) ? 7 : _direction - 1;
			setModel(_modelName, direction); 
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
		
		public function get readyEvent():EventSender { return _readyEvent; }
		
		public function get pet():PetTO { return _pet; }
		
		public function get modelName():String { return _modelName; }
		
		public function get content():MovieClip
		{
			 return _content;
		}
		
	}
}