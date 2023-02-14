package away3d.primitives
{
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.utils.*;
	import away3d.events.*;
	import away3d.materials.*;
	import away3d.primitives.data.*;
    
    /**
    * Creates a 3d cube primitive.
    */ 
    public class Cube extends AbstractPrimitive
    {
    	use namespace arcane
    	
    	private var _width:Number;
    	private var _height:Number;
    	private var _depth:Number;
    	private var _cubeMaterials:CubeMaterialsData;
    	private var _leftFaces:Array = [];
    	private var _rightFaces:Array = [];
    	private var _bottomFaces:Array = [];
    	private var _topFaces:Array = [];
    	private var _frontFaces:Array = [];
    	private var _backFaces:Array = [];
    	private var _cubeFace:Face;
    	private var _cubeFaceArray:Array;
    	private var _umin:Number;
    	private var _umax:Number;
    	private var _vmin:Number;
    	private var _vmax:Number;
    	
    	private function onCubeMaterialChange(event:MaterialEvent):void
    	{
    		switch (event.extra) {
    			case "left":
    				_cubeFaceArray = _leftFaces;
    				break;
    			case "right":
    				_cubeFaceArray = _rightFaces;
    				break;
    			case "bottom":
    				_cubeFaceArray = _bottomFaces;
    				break;
    			case "top":
    				_cubeFaceArray = _topFaces;
    				break;
    			case "front":
    				_cubeFaceArray = _frontFaces;
    				break;
    			case "back":
    				_cubeFaceArray = _backFaces;
    				break;
    			default:
    		}
    		
    		for each (_cubeFace in _cubeFaceArray)
    			_cubeFace.material = event.material as ITriangleMaterial;
    	}
    	
        private function buildCube(width:Number, height:Number, depth:Number):void
        {

            var v000:Vertex = createVertex(-width/2, -height/2, -depth/2); 
            var v001:Vertex = createVertex(-width/2, -height/2, +depth/2); 
            var v010:Vertex = createVertex(-width/2, +height/2, -depth/2); 
            var v011:Vertex = createVertex(-width/2, +height/2, +depth/2); 
            var v100:Vertex = createVertex(+width/2, -height/2, -depth/2); 
            var v101:Vertex = createVertex(+width/2, -height/2, +depth/2); 
            var v110:Vertex = createVertex(+width/2, +height/2, -depth/2); 
            var v111:Vertex = createVertex(+width/2, +height/2, +depth/2); 

            var uva:UV = createUV(_umax, _vmax);
            var uvb:UV = createUV(_umin, _vmax);
            var uvc:UV = createUV(_umin, _vmin);
            var uvd:UV = createUV(_umax, _vmin);
            
            //left face
            addFace(_leftFaces[0] = createFace(v000, v010, v001, _cubeMaterials.left, uvd, uva, uvc));
            addFace(_leftFaces[1] = createFace(v010, v011, v001, _cubeMaterials.left, uva, uvb, uvc));
            
            //right face
            addFace(_rightFaces[0] = createFace(v100, v101, v110, _cubeMaterials.right, uvc, uvd, uvb));
            addFace(_rightFaces[1] = createFace(v110, v101, v111, _cubeMaterials.right, uvb, uvd, uva));
            
            //bottom face
            addFace(_bottomFaces[0] = createFace(v000, v001, v100, _cubeMaterials.bottom, uvb, uvc, uva));
            addFace(_bottomFaces[1] = createFace(v001, v101, v100, _cubeMaterials.bottom, uvc, uvd, uva));
            
            //top face
            addFace(_topFaces[0] = createFace(v010, v110, v011, _cubeMaterials.top, uvc, uvd, uvb));
            addFace(_topFaces[1] = createFace(v011, v110, v111, _cubeMaterials.top, uvb, uvd, uva));
            
            //front face
            addFace(_frontFaces[0] = createFace(v000, v100, v010, _cubeMaterials.front, uvc, uvd, uvb));
            addFace(_frontFaces[1] = createFace(v100, v110, v010, _cubeMaterials.front, uvd, uva, uvb));
            
            //back face
            addFace(_backFaces[0] = createFace(v001, v011, v101, _cubeMaterials.back, uvd, uva, uvc));
            addFace(_backFaces[1] = createFace(v101, v011, v111, _cubeMaterials.back, uvc, uva, uvb));
        }
        
    	/**
    	 * Defines the width of the cube. Defaults to 100.
    	 */
    	public function get width():Number
    	{
    		return _width;
    	}
    	
    	public function set width(val:Number):void
    	{
    		if (_width == val)
    			return;
    		
    		_width = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the height of the cube. Defaults to 100.
    	 */
    	public function get height():Number
    	{
    		return _height;
    	}
    	
    	public function set height(val:Number):void
    	{
    		if (_height == val)
    			return;
    		
    		_height = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the depth of the cube. Defaults to 100.
    	 */
    	public function get depth():Number
    	{
    		return _depth;
    	}
    	
    	public function set depth(val:Number):void
    	{
    		if (_depth == val)
    			return;
    		
    		_depth = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the face materials of the cube.
    	 */
    	public function get cubeMaterials():CubeMaterialsData
    	{
    		return _cubeMaterials;
    	}
    	
    	public function set cubeMaterials(val:CubeMaterialsData):void
    	{
    		if (_cubeMaterials == val)
    			return;
    		
    		if (_cubeMaterials)
    			_cubeMaterials.addOnMaterialChange(onCubeMaterialChange);
    		
    		_cubeMaterials = val;
    		
    		_cubeMaterials.addOnMaterialChange(onCubeMaterialChange)
    	}
		/**
		 * Creates a new <code>Cube</code> object.
		 *
		 * @param	init			[optional]	An initialisation object for specifying default instance properties.
		 */
        public function Cube(init:Object = null)
        {
            super(init);
            
            _width  = ini.getNumber("width",  100, {min:0});
            _height = ini.getNumber("height", 100, {min:0});
            _depth  = ini.getNumber("depth",  100, {min:0});
            _umin = ini.getNumber("umin", 0, {min:0, max:1});
            _umax = ini.getNumber("umax", 1, {min:0, max:1});
            _vmin = ini.getNumber("vmin", 0, {min:0, max:1});
            _vmax = ini.getNumber("vmax", 1, {min:0, max:1});
            _cubeMaterials  = ini.getCubeMaterials("faces");
            
            if (!_cubeMaterials)
            	_cubeMaterials  = ini.getCubeMaterials("cubeMaterials");
            	
            if (!_cubeMaterials)
            	_cubeMaterials = new CubeMaterialsData();
            
    		_cubeMaterials.addOnMaterialChange(onCubeMaterialChange);
    		
    		buildCube(_width, _height, _depth);
    		
    		type = "Cube";
        	url = "primitive";
        }
        
		/**
		 * @inheritDoc
		 */
    	public override function buildPrimitive():void
    	{
    		super.buildPrimitive();
    		
             buildCube(_width, _height, _depth);
    	}
    } 
}