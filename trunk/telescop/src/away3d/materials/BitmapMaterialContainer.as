package away3d.materials
{
	import away3d.containers.*;
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.utils.*;
	import away3d.events.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * Container for caching multiple bitmapmaterial objects.
	 * Renders each material by caching a bitmapData surface object for each face.
	 * For continually updating materials, use <code>CompositeMaterial</code>.
	 * 
	 * @see away3d.materials.CompositeMaterial
	 */
	public class BitmapMaterialContainer extends BitmapMaterial implements ITriangleMaterial, ILayerMaterial
	{
		use namespace arcane;
		
		private var _cache:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _containerDictionary:Dictionary = new Dictionary(true);
		private var _cacheDictionary:Dictionary;
		private var _containerVO:FaceVO;
		private var _faceWidth:int;
		private var _faceHeight:int;
		private var _forceRender:Boolean;
		private var _face:Face;
		private var _material:ILayerMaterial;
        private var _viewDictionary:Dictionary = new Dictionary(true);
        
        private function onMaterialUpdate(event:MaterialEvent):void
        {
        	dispatchEvent(event);
        }
        
		/**
		 * An array of bitmapmaterial objects to be overlayed sequentially.
		 */
		protected var materials:Array;
        
		/**
		 * @inheritDoc
		 */
		protected override function updateRenderBitmap():void
        {
        	update();
        }
        
		/**
		 * @inheritDoc
		 */
		protected override function getMapping(tri:DrawTriangle):Matrix
        {
        	_face = tri.face;
    		_faceVO = getFaceVO(tri.face, tri.source, tri.view);
    		
        	if (!_cacheDictionary || !_cacheDictionary[_faceVO]) {
        		
	    		
	        	//check to see if face drawtriangle needs updating
	        	if (!_faceVO.texturemapping) {
	        		
	        		//update face bitmapRect
	        		_face.bitmapRect = new Rectangle(int(_width*_face.minU), int(_height*(1 - _face.maxV)), int(_width*(_face.maxU-_face.minU)+2), int(_height*(_face.maxV-_face.minV)+2));
	        		_faceWidth = _face.bitmapRect.width;
	        		_faceHeight = _face.bitmapRect.height;
	        		
	        		//update texturemapping
	        		_faceVO.invtexturemapping = tri.transformUV(this).clone();
	        		_faceVO.texturemapping = _faceVO.invtexturemapping.clone();
	        		_faceVO.texturemapping.invert();
	        		
	        		//resize bitmapData for container
	        		_faceVO.resize(_faceWidth, _faceHeight, transparent);
	        	}
	        	
	        	if (_cacheDictionary)
	        		_cacheDictionary[_faceVO] = _faceVO;
        		
	    		//call renderFace on each material
	    		for each (_material in materials)
	        		_faceVO = _material.renderBitmapLayer(tri, _bitmapRect, _faceVO);
	        		
	        	_faceVO.updated = false;
	        }
        	
        	//check to see if tri texturemapping need updating
        	if (!_faceVO.texturemapping) {
        		//update texturemapping
        		_faceVO.invtexturemapping = tri.transformUV(this).clone();
        		_faceVO.texturemapping = _faceVO.invtexturemapping.clone();
        		_faceVO.texturemapping.invert();
        	}
        	
        	if (_cacheDictionary)
        		_renderBitmap = _cacheDictionary[_faceVO].bitmap;
        	else
        		_renderBitmap = _faceVO.bitmap;
        	
        	return _faceVO.texturemapping;
        }
		
		/**
		 * Defines whether the caching bitmapData objects are transparent
		 */
		public var transparent:Boolean;
		
		/**
		 * Defines whether each created bitmapData surface is to be cached, or updated every frame.
		 * Updating all bitmapData surface objects is costly, so needs to be used sparingly.
		 */
		public function get cache():Boolean
		{
			return _cache;
		}
		
		public function set cache(val:Boolean):void
		{
			_cache = val;
			if (val)
				_cacheDictionary = new Dictionary(true);
			else
				_cacheDictionary = null; 
		}
    	
		/**
		 * Creates a new <code>BitmapMaterialContainer</code> object.
		 * 
		 * @param	width				The containing width of the texture, applied to all child materials.
		 * @param	height				The containing height of the texture, applied to all child materials.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
		public function BitmapMaterialContainer(width:int, height:int, init:Object = null)
		{
			super(new BitmapData(width, height, true, 0x00FFFFFF), init);
			
			materials = ini.getArray("materials");
			_width = width;
			_height = height;
			_bitmapRect = new Rectangle(0, 0, _width, _height);
            
            for each (_material in materials)
            	_material.addOnMaterialUpdate(onMaterialUpdate);
			
			transparent = ini.getBoolean("transparent", true);
			cache = ini.getBoolean("cache", true);
		}
		        
        public function addMaterial(material:ILayerMaterial):void
        {
        	material.addOnMaterialUpdate(onMaterialUpdate);
        	materials.push(material);
        }
        
        public function removeMaterial(material:ILayerMaterial):void
        {
        	var index:int = materials.indexOf(material);
        	
        	if (index == -1)
        		return;
        	
        	material.removeOnMaterialUpdate(onMaterialUpdate);
        	
        	materials.splice(index, 1);
        }
        
		/**
		 * Clear and updates the currrent bitmapData surface on all faces.
		 */
		public function update():void
		{
			if (_cache)
				_cacheDictionary = new Dictionary(true);
		}
		
		/**
		 * Creates a new <code>BitmapMaterialContainer</code> object.
		 *
		 * @param	width				The containing width of the texture, applied to all child materials.
		 * @param	height				The containing height of the texture, applied to all child materials.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public override function updateMaterial(source:Object3D, view:View3D):void
        {
        	if (_colorTransformDirty)
        		updateColorTransform();
        	
        	_blendModeDirty = false;
        	
        	for each (_material in materials)
        		_material.updateMaterial(source, view);
        }
        
        public override function getFaceVO(face:Face, source:Object3D, view:View3D = null):FaceVO
        {
        	if ((_faceDictionary = _viewDictionary[view])) {
        		if ((_faceVO = _faceDictionary[face]))
	        		return _faceVO;
        	} else {
        		_faceDictionary = _viewDictionary[view] = new Dictionary(true);
        	}
        	
        	return _faceDictionary[face] = new FaceVO();
        }
        
        public override function removeFaceDictionary():void
        {
			_viewDictionary = new Dictionary(true);
        }
        
		/**
		 * @private
		 */
        public override function renderLayer(tri:DrawTriangle, layer:Sprite, level:int):void
        {
        	throw new Error("Not implemented");
        }
        
		/**
		 * @inheritDoc
		 */
        public override function renderBitmapLayer(tri:DrawTriangle, containerRect:Rectangle, parentFaceVO:FaceVO):FaceVO
		{
			//check to see if faceDictionary exists
			if (!(_faceVO = _faceDictionary[tri]))
				_faceVO = _faceDictionary[tri] = new FaceVO();
			
			//get width and height values
			_faceWidth = tri.face.bitmapRect.width;
    		_faceHeight = tri.face.bitmapRect.height;

			//check to see if bitmapContainer exists
			if (!(_containerVO = _containerDictionary[tri]))
				_containerVO = _containerDictionary[tri] = new FaceVO();
			
			//resize container
			if (parentFaceVO.resized) {
				parentFaceVO.resized = false;
				_containerVO.resize(_faceWidth, _faceHeight, transparent);
			}
			
			//call renderFace on each material
    		for each (_material in materials)
        		_containerVO = _material.renderBitmapLayer(tri, containerRect, _containerVO);
			
			//check to see if face update can be skipped
			if (parentFaceVO.updated || _containerVO.updated) {
				parentFaceVO.updated = false;
				_containerVO.updated = false;
				
				//reset booleans
				_faceVO.invalidated = false;
				_faceVO.cleared = false;
				_faceVO.updated = true;
        		
				//store a clone
				_faceVO.bitmap = parentFaceVO.bitmap.clone();
				_faceVO.bitmap.lock();
				
				_sourceVO = _faceVO;
	        	
	        	//draw into faceBitmap
	        	if (_blendMode == BlendMode.NORMAL && !_colorTransform)
	        		_faceVO.bitmap.copyPixels(_containerVO.bitmap, _containerVO.bitmap.rect, _zeroPoint, null, null, true);
	        	else
					_faceVO.bitmap.draw(_containerVO.bitmap, null, _colorTransform, _blendMode);
	  		}
	  		
	  		_containerVO.updated = false;
	  		
	  		return _faceVO;        	
		}
	}
}