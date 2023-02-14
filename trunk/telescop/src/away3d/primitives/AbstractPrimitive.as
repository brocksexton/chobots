package away3d.primitives
{
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.math.*;
	import away3d.core.utils.*;
	import away3d.materials.*;
    
    /**
    * Creates a 3d cone primitive.
    */ 
    public class AbstractPrimitive extends Mesh
    {
    	use namespace arcane;
		/** @private */
		arcane var _v:Vertex;
		/** @private */
		arcane var _vStore:Array = new Array();
		/** @private */
        arcane var _vActive:Array = new Array();
		/** @private */
		arcane var _uv:UV;
		/** @private */
		arcane var _uvStore:Array = new Array();
		/** @private */
        arcane var _uvActive:Array = new Array();
		/** @private */
		arcane var _face:Face;
		/** @private */
		arcane var _faceStore:Array = new Array();
		/** @private */
        arcane var _faceActive:Array = new Array();
		/** @private */
        arcane var _primitiveDirty:Boolean;
		/** @private */
		arcane function createVertex(x:Number = 0, y:Number = 0, z:Number = 0):Vertex
		{
			if (_vStore.length) {
            	_vActive.push(_v = _vStore.pop());
	            _v._x = x;
	            _v._y = y;
	            _v._z = z;
   			} else {
            	_vActive.push(_v = new Vertex(x, y, z));
      		}
            return _v;
		}
		/** @private */
		arcane function createUV(u:Number = 0, v:Number = 0):UV
		{
			if (_uvStore.length) {
            	_uvActive.push(_uv = _uvStore.pop());
	            _uv.u = u;
	            _uv.v = v;
   			} else {
            	_uvActive.push(_uv = new UV(u, v));
      		}
            return _uv;
		}
		/** @private */
		arcane function createFace(v0:Vertex, v1:Vertex, v2:Vertex, material:ITriangleMaterial = null, uv0:UV = null, uv1:UV = null, uv2:UV = null):Face
		{
			if (_faceStore.length) {
            	_faceActive.push(_face = _faceStore.pop());
	            _face.v0 = v0;
	            _face.v1 = v1;
	            _face.v2 = v2;
	            _face.material = material;
	            _face.uv0 = uv0;
	            _face.uv1 = uv1;
	            _face.uv2 = uv2;
			} else {
            	_faceActive.push(_face = new Face(v0, v1, v2, material, uv0, uv1, uv2));
   			}
            return _face;
		}
		
		/**
		 * Creates a new <code>AbstractPrimitive</code> object.
		 *
		 * @param	init			[optional]	An initialisation object for specifying default instance properties
		 */
		public function AbstractPrimitive(init:Object = null)
		{
			super(init);
		}
		
		public override function updateObject():void
    	{
    		if (_primitiveDirty)
        		buildPrimitive();
        	
        	super.updateObject();
     	}
     	
		/**
		 * Builds the vertex, face and uv objects that make up the 3d primitive.
		 */
    	public function buildPrimitive():void
    	{
    		_primitiveDirty = false;
    		_objectDirty = true;
    		
    		//remove all elements from the mesh
    		for each (_face in faces)
    			removeFace(_face);
    		
    		//clear vertex objects
    		_vStore = _vStore.concat(_vActive);
        	_vActive = new Array();
    		
    		//clear uv objects
    		_uvStore = _uvStore.concat(_uvActive);
        	_uvActive = new Array();
        	
        	//clear face objects
    		_faceStore = _faceStore.concat(_faceActive);
        	_faceActive = new Array();
    	}
    }
}