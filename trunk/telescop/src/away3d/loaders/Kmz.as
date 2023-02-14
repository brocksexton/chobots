package away3d.loaders
{
    import away3d.containers.*;
    import away3d.core.*;
    import away3d.core.base.*;
    import away3d.core.utils.*;
    import away3d.events.LoaderEvent;
    import away3d.loaders.data.*;
    import away3d.loaders.utils.*;
    import away3d.materials.*;
    
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.utils.ByteArray;
    
    import nochump.util.zip.*;

    /**
    * File loader for the KMZ 4 file format (exported from Google Sketchup).
    */
    public class Kmz extends AbstractParser
    {
		use namespace arcane;
    	
        private var collada:XML;
        private var _materialData:MaterialData;
        private var _face:Face;
    	private var kmzFile:ZipFile;
    	
        private function parseKmz(datastream:ByteArray, init:Object):void
        {
        	
            kmzFile = new ZipFile(datastream);
			var totalMaterials:int = kmzFile.entries.join("@").split(".jpg").length;
			for(var i:int = 0; i < kmzFile.entries.length; i++) {
				var entry:ZipEntry = kmzFile.entries[i];
				var data:ByteArray = kmzFile.getInput(entry);
				if(entry.name.indexOf(".dae")>-1 && entry.name.indexOf("models/")>-1) {
					collada = new XML(data.toString());
					container = Collada.parse(collada, init);
					if (container is Object3DLoader) {
						(container as Object3DLoader).parser.container.materialLibrary.loadRequired = false;
						(container as Object3DLoader).addOnSuccess(onParseGeometry);
					} else {
						parseImages();
					}
				}
			}
        }
        
        private function onParseGeometry(event:LoaderEvent):void
        {
        	container = event.loader.handle;
        	parseImages();
        }
        
        private function parseImages():void
        {
        	materialLibrary = container.materialLibrary;
			materialLibrary.loadRequired = false;
			
			var totalMaterials:int = kmzFile.entries.join("@").split(".jpg").length;
			for(var i:int = 0; i < kmzFile.entries.length; i++) {
				var entry:ZipEntry = kmzFile.entries[i];
				var data:ByteArray = kmzFile.getInput(entry);
				if((entry.name.indexOf(".jpg")>-1 || entry.name.indexOf(".png")>-1) && entry.name.indexOf("images/")>-1) {
					var _loader:Loader = new Loader();
					_loader.name = "../" + entry;
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBitmapCompleteHandler);
					_loader.loadBytes(data);
				}
			}
        }
        
        private function loadBitmapCompleteHandler(e:Event):void {
			var loader:Loader = Loader(e.target.loader);
			
			//pass material instance to correct materialData
			for each (_materialData in materialLibrary) {
				if (_materialData.textureFileName == loader.name) {
					_materialData.textureBitmap = Bitmap(loader.content).bitmapData;
					_materialData.material = new BitmapMaterial(_materialData.textureBitmap);
					for each(_face in _materialData.elements)
						_face.material = _materialData.material as ITriangleMaterial;
				}
			}
		}
        
        /**
        * Reference container for all materials used in the kmz scene.
        */
    	public var materialLibrary:MaterialLibrary;
    	
    	/**
    	 * Container data object used for storing the parsed kmz data structure.
    	 */
        public var containerData:ContainerData;
		
		/**
		 * Creates a new <code>Kmz</code> object. Not intended for direct use, use the static <code>parse</code> or <code>load</code> methods.
		 * This loader is only compatible with the kmz 4 googleearth format that is exported from Google Sketchup.
		 * 
		 * @param	datastream			The binary zip data of a loaded file.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 * 
		 * @see away3d.loaders.Kmz#parse()
		 * @see away3d.loaders.Kmz#load()
		 */
        public function Kmz(data:*, init:Object = null)
        {
            parseKmz(Cast.bytearray(data), init);
        }

		/**
		 * Creates a 3d container object from the raw binary data of a kmz file.
		 * 
		 * @param	data				The birnay zip data of a loaded file.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 * @param	loader	[optional]	Not intended for direct use.
		 * 
		 * @return						A 3d container object representation of the kmz file.
		 */
        public static function parse(data:*, init:Object = null, loader:Object3DLoader = null):ObjectContainer3D
        {
            return Object3DLoader.parseGeometry(data, Kmz, init).handle as ObjectContainer3D;
        }
    	
    	/**
    	 * Loads and parses a kmz file into a 3d container object.
    	 * 
    	 * @param	url					The url location of the file to load.
    	 * @param	init	[optional]	An initialisation object for specifying default instance properties.
    	 * @return						A 3d loader object that can be used as a placeholder in a scene while the file is loading.
    	 */
        public static function load(url:String, init:Object = null):Object3DLoader
        {
            return Object3DLoader.loadGeometry(url, Kmz, true, init);
        }
        
        public override function parseNext():void
        {
        	notifySuccess();
        }
    }
}
