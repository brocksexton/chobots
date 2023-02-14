package away3d.core.project
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.math.*;
	import away3d.materials.*;
	
	import flash.utils.*;
	
	public class AbstractProjector
	{
		private var _source:Object3D;
		private var _seg:DrawSegment;
		private var _tri:DrawTriangle;
		private var _dtStore:Array = new Array();
        private var _dtActive:Array = new Array();
        private var _dsStore:Array = new Array();
        private var _dsActive:Array = new Array();
        
		protected var viewDictionary:Dictionary;
		
		protected var primitiveDictionary:Dictionary;
        
		public function get source():Object3D
		{
			return _source;
		}
		
		public function set source(val:Object3D):void
		{
			if (_source == val)
				return;
			
			_source = val;
			
			viewDictionary = new Dictionary(true);
		}
		
		public function primitives(view:View3D, viewTransform:Matrix3D, consumer:IPrimitiveConsumer):void
		{
			if (!(primitiveDictionary = viewDictionary[view]))
				primitiveDictionary = viewDictionary[view] = new Dictionary(true);
		}
		
	    public function createDrawSegment(view:View3D, source:Object3D, material:ISegmentMaterial, v0:ScreenVertex, v1:ScreenVertex):DrawSegment
	    {
	        if (_dsStore.length) {
	        	_dsActive.push(_seg = _dsStore.pop());
	    	} else {
	        	_dsActive.push(_seg = new DrawSegment());
	            _seg.source = source;
	            _seg.create = createDrawSegment;
	        }
	        
	        _seg.view = view;
	        _seg.material = material;
	        _seg.v0 = v0;
	        _seg.v1 = v1;
	        _seg.calc();
	        
	        return _seg;
	    }
	    
		public function createDrawTriangle(view:View3D, source:Object3D, face:Face, material:ITriangleMaterial, v0:ScreenVertex, v1:ScreenVertex, v2:ScreenVertex, uv0:UV, uv1:UV, uv2:UV):DrawTriangle
		{
			if (_dtStore.length) {
	        	_dtActive.push(_tri = _dtStore.pop());
	   		} else {
	        	_dtActive.push(_tri = new DrawTriangle());
		        _tri.source = source;
		        _tri.create = createDrawTriangle;
		        _tri.generated = true;
	        }
	        
	        _tri.view = view;
	        _tri.face = face;
	        _tri.material = material;
	        _tri.v0 = v0;
	        _tri.v1 = v1;
	        _tri.v2 = v2;
	        _tri.uv0 = uv0;
	        _tri.uv1 = uv1;
	        _tri.uv2 = uv2;
	    	_tri.calc();
	        
	        return _tri;
		}
	}
}