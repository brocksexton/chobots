package com.kavalok.clothes
{
	import com.kavalok.utils.ClassLibrary;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	import mx.containers.Tile;
	import mx.controls.FileSystemEnumerationMode;
	import mx.controls.FileSystemList;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	public class MainWindow extends WindowedApplication
	{
		public static const CLOTHES_CLASS:String = 'McClothes';
		public static const SETTINGS_FILE:String = 'clothes.ini';
		
		public var tiles:Tile;
		public var swfList:FileSystemList;
		public var txtPath:Text;
		
		private var _loader:Loader;
		private var _models:Array = [];
		private var _workspace:String = '';
		private var _coreDomain:ApplicationDomain;
		
		private var _lib:ClassLibrary = new ClassLibrary();
		private var _numBodies:int;
		
		public function onInitialize(event:FlexEvent):void
		{
			readClothesPath();
			
			if (_workspace)
			{
				updateClothes();
				initClothesList();
				loadAssets();
			}
		}
		
		private function loadAssets():void
		{
			var urlList:Array = [];
			urlList.push(bodyURL());				
			_lib.callbackOnReady(onAssetsReady, urlList);
		}
		
		private function bodyURL():String
		{
			//return _workspace + '/charBody/flash-resources/default.swf';		
			return 'http://chobots.net/game/resources/charBody/default.swf';
		}
		
		private function onAssetsReady():void
		{
			loadCoreSWF();
		}
		
		private function loadCoreSWF():void
		{
			//var url:String = _workspace + '/kavalok_core/flash-resources/charModels.swf';
			var url:String = "http://chobots.net/game/resources/kavalok_core/charModels.swf";
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCoreComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onCoreFault);
			_loader.load(new URLRequest(url));
		}
		
		private function onCoreFault(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function onCoreComplete(event:Event):void
		{
			_coreDomain = LoaderInfo(event.target).applicationDomain;
			createModels();			
		}
		
		private function saveClothesPath():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(SETTINGS_FILE);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTF(_workspace);
			stream.close();
		}
		
		private function initClothesList():void
		{
			swfList.extensions = ['swf'];
			swfList.showExtensions = false;
			swfList.enumerationMode = FileSystemEnumerationMode.FILES_ONLY;
		}
		
		public function clear(event:Event = null):void
		{
			for each (var model:Model in _models)
			{
				model.update();
			}
			
		}
		
		public function refresh(event:Event):void
		{
			try
			{
				swfList.refresh();
			}
			catch (e:Error)
			{
			}
			onClothesSelected();
		}
		
		private function updateClothes():void
		{
			txtPath.text = _workspace;
			
			var file:File = new File(_workspace + '/clothes/flash-resources/');
			
			if (file.exists)
				swfList.navigateTo(file);
		}
		
		public function selectFolder(event:MouseEvent):void
		{
			var file:File = new File(_workspace);
			file.addEventListener(Event.SELECT, onClothesFolderSelected);
			file.browseForDirectory('Select clothes folder');
		}
		
		private function onClothesFolderSelected(event:Event):void
		{
			_workspace = File(event.target).nativePath;
			saveClothesPath();
			updateClothes();
		}
		
		private function readClothesPath():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(SETTINGS_FILE);
			var stream:FileStream = new FileStream();
			
			try
			{
				stream.open(file, FileMode.READ);
				_workspace = stream.readUTF();
				stream.close();
			}
			catch (error:Error)
			{
				_workspace = null;
			}
		}
		
		public function onClothesSelected(event:ListEvent = null):void
		{
			var url:String = swfList.selectedPath;
			trace("selectedPath:"  + swfList.selectedPath);
			if(url && url.length > 4)
				url = "http://chobots.net/game/resources/clothes/" + swfList.selectedPath.split("/")[6];
			
			clear();
			
			if (url)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onClothesLoaded);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
				_loader.load(new URLRequest(url));
			}
		}
		
		private function onLoadFailed(event:Event):void
		{
		}
		
		private function onClothesLoaded(event:Event):void
		{
			var clothesDomain:ApplicationDomain = LoaderInfo(event.target).applicationDomain;
			
			for each (var model:Model in _models)
			{
				model.update(clothesDomain);
			}
		}
		
		private function createModels():void
		{
			addModel('ModelStay0');
			addModel('ModelStay1');
			addModel('ModelStay2');
			addModel('ModelStay6');
			addModel('ModelStay7');
			
			addModel('ModelWalk0');
			addModel('ModelWalk1');
			addModel('ModelWalk2');
			addModel('ModelWalk6');
			addModel('ModelWalk7');
			
			addModel('ModelPlayDrum');
			addModel('PlayGuitarClassic');
			addModel('PlayGuitarRock');
			addModel('PlaySax');
			addModel('PlayVinyl');
			
			
			/*addModel('ModelTake0');
			addModel('ModelTake1');
			addModel('ModelTake2');
			addModel('ModelTake6');
			addModel('ModelTake7');*/
			
			/*addModel('ModelThrow0');
			addModel('ModelThrow1');
			addModel('ModelThrow2');
			addModel('ModelThrow6');
			addModel('ModelThrow7');*/
			
			addModel('ModelDance0');
			addModel('ModelDance1');
			addModel('ModelDance2');
			addModel('ModelDance3');
			addModel('ModelDance4');
			addModel('ModelDance5');
			addModel('ModelDance6');
			addModel('ModelDance7');
			addModel('ModelDance8');
			/*addModel('ModelDance9');
			addModel('ModelDance10');
			addModel('ModelDance11');
			addModel('ModelDance12');
			addModel('ModelDance13');
			addModel('ModelDance14');
			addModel('ModelDance15');
			addModel('ModelDance16');
			addModel('ModelDance17');
			addModel('ModelDance18');
			addModel('ModelDance19');
			addModel('ModelDance20');*/
		}
		
		private function addModel(className:String):void
		{
			var bodyDomain:ApplicationDomain = _lib.getDomain(bodyURL());
			
			if (_coreDomain.hasDefinition(className))
			{
				var model:Model = new Model(className, _coreDomain, bodyDomain);
				tiles.addChild(model);
				_models.push(model);
			}
		}
		
	}
}
import mx.core.UIComponent;
import flash.display.MovieClip;
import flash.utils.getQualifiedClassName;
import flash.geom.Matrix;
import flash.system.ApplicationDomain;
import com.kavalok.utils.SpriteDecorator;
import mx.states.AddChild;
import flash.events.Event;
import flash.display.Sprite;


internal class Model extends UIComponent
{
	private var _className:String;
	private var _model:MovieClip;
	private var _coreDomain:ApplicationDomain;
	private var _bodyDomain:ApplicationDomain;
	private var _clothesDomain:ApplicationDomain;
	
	public function Model(className:String, coreDomain:ApplicationDomain, bodyDomain:ApplicationDomain)
	{
		_className = className;
		_coreDomain = coreDomain;
		_bodyDomain = bodyDomain;
		width = 100;
		height = 100;
		update();
	}
	
	public function update(clothesDomain:ApplicationDomain = null):void
	{
		_clothesDomain = clothesDomain;
		
		if (!clothesDomain)
		{
			if (_model)
			{
				_model.stop();
				removeChild(_model);
			}
			
			var modelClass:Class = Class(_coreDomain.getDefinition(_className));
			
			_model = new modelClass();
			_model.x = 0.5 * width;
			_model.y = height;
			_model.addEventListener(Event.CHANGE, decorateModel);
			
			var board:Sprite = new Sprite();
			board.name = '_ChBoard';
			_model.addChildAt(board, 0);
			
			
			addChild(_model);
		}
		decorateModel();
	}
	
	private function decorateModel(e:Event = null):void
	{
		var assets:Array =
			[
				{
					domain: _bodyDomain,
					color: int(Math.random() * 0xFFFFFF) 
				}
			]
		
		if (_clothesDomain)
		{
			assets.push(
				{
					domain: _clothesDomain,
					color: int(Math.random() * 0xFFFFFF)
				}
			)
		}
		
		SpriteDecorator.decorateModel(_model, assets, false);
	}
}