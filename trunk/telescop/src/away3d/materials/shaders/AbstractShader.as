package away3d.materials.shaders
{
	import away3d.containers.*;
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.light.*;
	import away3d.core.math.*;
	import away3d.core.render.*;
	import away3d.core.utils.*;
	import away3d.events.*;
	import away3d.materials.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;	
	
	/**
	 * Base class for shaders.
    * Not intended for direct use - use one of the shading materials in the materials package.
    */
    public class AbstractShader extends EventDispatcher implements ILayerMaterial
    {
		use namespace arcane;
        /** @private */
		arcane var _materialupdated:MaterialEvent;
        /** @private */
        arcane var _faceDictionary:Dictionary = new Dictionary(true);
        /** @private */
        arcane var _spriteDictionary:Dictionary = new Dictionary(true);
        /** @private */
        arcane var _sprite:Sprite;
        /** @private */
        arcane var _shapeDictionary:Dictionary = new Dictionary(true);
        /** @private */
        arcane var _shape:Shape;
        /** @private */
		arcane var eTri0x:Number;
        /** @private */
		arcane var eTri0y:Number;
        /** @private */
		arcane var eTri1x:Number;
        /** @private */
		arcane var eTri1y:Number;
        /** @private */
		arcane var eTri2x:Number;
        /** @private */
		arcane var eTri2y:Number;
        /** @private */
        arcane var _s:Shape = new Shape();
        /** @private */
		arcane var _graphics:Graphics;
        /** @private */
		arcane var _bitmapRect:Rectangle;
        /** @private */
		arcane var _source:Mesh;
        /** @private */
		arcane var _session:AbstractRenderSession;
        /** @private */
		arcane var _view:View3D;
        /** @private */
		arcane var _face:Face;
        /** @private */
		arcane var _lights:ILightConsumer;
        /** @private */
		arcane var _parentFaceVO:FaceVO;
        /** @private */
		arcane var _n0:Number3D;
        /** @private */
		arcane var _n1:Number3D;
        /** @private */
		arcane var _n2:Number3D;
        /** @private */
        arcane var _dict:Dictionary;
        /** @private */
		arcane var ambient:AmbientLight;
        /** @private */
		arcane var directional:DirectionalLight;
        /** @private */
		arcane var _faceVO:FaceVO;
        /** @private */
		arcane var _normal0:Number3D = new Number3D();
        /** @private */
		arcane var _normal1:Number3D = new Number3D();
        /** @private */
		arcane var _normal2:Number3D = new Number3D();
        /** @private */
		arcane var _mapping:Matrix = new Matrix();
		/** @private */
        arcane function notifyMaterialUpdate():void
        {	
            if (!hasEventListener(MaterialEvent.MATERIAL_UPDATED))
                return;
			
            if (_materialupdated == null)
                _materialupdated = new MaterialEvent(MaterialEvent.MATERIAL_UPDATED, this);
                
            dispatchEvent(_materialupdated);
        }
        /** @private */
        arcane function clearShapeDictionary():void
        {
        	for each (_shape in _shapeDictionary)
        		_shape.graphics.clear();
        }
        /** @private */
        arcane function clearLightingShapeDictionary():void
        {
        	
        	for each (_dict in _shapeDictionary)
        		for each (_shape in _dict)
	        		_shape.graphics.clear();
        }
        /** @private */
		arcane final function contains(v0x:Number, v0y:Number, v1x:Number, v1y:Number, v2x:Number, v2y:Number, x:Number, y:Number):Boolean
        {   
            if (v0x*(y - v1y) + v1x*(v0y - y) + x*(v1y - v0y) < -0.001)
                return false;

            if (v0x*(v2y - y) + x*(v0y - v2y) + v2x*(y - v0y) < -0.001)
                return false;

            if (x*(v2y - v1y) + v1x*(y - v2y) + v2x*(v1y - y) < -0.001)
                return false;

            return true;
        }
        
        /**
        * Instance of the Init object used to hold and parse default property values
        * specified by the initialiser object in the 3d object constructor.
        */
        protected var ini:Init;
        
        /**
        * Clears face value objects when shader requires updating
        * 
        * @param	source		The parent 3d object of the face.
        * @param	view		The view rendering the draw triangle.
        * 
        * @see away3d.core.utils.FaceVO
        */
        protected function clearFaceDictionary(source:Object3D, view:View3D):void
        {
        	throw new Error("Not implemented");
        }
        
		/**
		 * Returns a shape object for use by environment shaders.
		 * 
		 * @param	layer	The parent layer of the triangle
		 * @return			The resolved shape object to use for drawing
		 */
        protected function getShape(layer:Sprite):Shape
        {
        	_session = _source.session;
        	if (_session != _view.scene.session) {
        		//check to see if source shape exists
	    		if (!(_shape = _shapeDictionary[_session]))
	    			layer.addChild(_shape = _shapeDictionary[_session] = new Shape());
        	} else {
	        	//check to see if face shape exists
	    		if (!(_shape = _shapeDictionary[_face]))
	    			layer.addChild(_shape = _shapeDictionary[_face] = new Shape());
        	}
        	return _shape;
        }
        
        /**
        * Renders the shader to the specified face.
        * 
        * @param	face	The face object being rendered.
        */
        protected function renderShader(tri:DrawTriangle):void
        {
        	throw new Error("Not implemented");
        }
        
		/**
		 * Returns a shape object for use by light shaders
		 * 
		 * @param	layer	The parent layer of the triangle.
		 * @param	light	The light primitive.
		 * @return			The resolved shape object to use for drawing.
		 */
        protected function getLightingShape(layer:Sprite, light:LightPrimitive):Shape
        {
        	_session = _source.session;
        	if (_session != _view.scene.session) {
    			if (!_shapeDictionary[_session])
    				_shapeDictionary[_session] = new Dictionary(true);
        		//check to see if source shape exists
	    		if (!(_shape = _shapeDictionary[_session][light]))
	    			layer.addChild(_shape = _shapeDictionary[_session][light] = new Shape());
        	} else {
        		if (!_shapeDictionary[_face])
    				_shapeDictionary[_face] = new Dictionary(true);
	        	//check to see if face shape exists
	    		if (!(_shape = _shapeDictionary[_face][light]))
	    			layer.addChild(_shape = _shapeDictionary[_face][light] = new Shape());
        	}
        	return _shape;
        }
        
    	/**
    	 * Determines if the shader bitmap is smoothed (bilinearly filtered) when drawn to screen
    	 */
        public var smooth:Boolean;
        
        /**
        * Determines if faces with the shader applied are drawn with outlines
        */
        public var debug:Boolean;
        
        /**
        * Defines a blendMode value for the shader bitmap.
        */
        public var blendMode:String;
    	
		/**
		 * Creates a new <code>AbstractShader</code> object.
		 * 
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function AbstractShader(init:Object = null)
        {
            ini = Init.parse(init);
            
            smooth = ini.getBoolean("smooth", false);
            debug = ini.getBoolean("debug", false);
            blendMode = ini.getString("blendMode", BlendMode.NORMAL);
            
        }
        
		/**
		 * @inheritDoc
		 */
		public function updateMaterial(source:Object3D, view:View3D):void
        {
        	throw new Error("Not implemented");
        }
        
		/**
		 * @inheritDoc
		 */
        public function renderLayer(tri:DrawTriangle, layer:Sprite, level:int):void
        {
        	_source = tri.source as Mesh;
			_view = tri.view;
			_face = tri.face;
			_lights = tri.source.lightarray;
        }
        
		/**
		 * @inheritDoc
		 */
        public function renderBitmapLayer(tri:DrawTriangle, containerRect:Rectangle, parentFaceVO:FaceVO):FaceVO
        {
        	_source = tri.source as Mesh;
			_view = tri.view;
			_parentFaceVO = parentFaceVO;
			
			_faceVO = getFaceVO(tri.face, _source, _view);
			
			//pass on inverse texturemapping
			_faceVO.invtexturemapping = parentFaceVO.invtexturemapping;
			
			//pass on resize value
			if (parentFaceVO.resized) {
				parentFaceVO.resized = false;
				_faceVO.resized = true;
			}
			
			//check to see if rendering can be skipped
			if (parentFaceVO.updated || _faceVO.invalidated) {
				parentFaceVO.updated = false;
				
				//retrieve the bitmapRect
				_bitmapRect = tri.face.bitmapRect;
				
				//reset booleans
				if (_faceVO.invalidated)
					_faceVO.invalidated = false;
				else 
					_faceVO.updated = true;
				
				//store a clone
				_faceVO.bitmap = parentFaceVO.bitmap;
				
				//draw shader
				renderShader(tri);
			}
			
			return _faceVO;
        }
        
		/**
		 * @inheritDoc
		 */
        public function getFaceVO(face:Face, source:Object3D, view:View3D = null):FaceVO
        {
        	if ((_faceVO = _faceDictionary[face]))
        		return _faceVO;
        	
        	return _faceDictionary[face] = new FaceVO();
        }
        
        public function removeFaceDictionary():void
        {
			_faceDictionary = new Dictionary(true);
        }
        
		/**
		 * @inheritDoc
		 */
        public function get visible():Boolean
        {
            return true;
        }
        
		/**
		 * @inheritDoc
		 */
        public function addOnMaterialUpdate(listener:Function):void
        {
        	addEventListener(MaterialEvent.MATERIAL_UPDATED, listener, false, 0, true);
        }
        
		/**
		 * @inheritDoc
		 */
        public function removeOnMaterialUpdate(listener:Function):void
        {
        	removeEventListener(MaterialEvent.MATERIAL_UPDATED, listener, false);
        }
    }
}
