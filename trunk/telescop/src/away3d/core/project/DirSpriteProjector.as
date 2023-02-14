package away3d.core.project
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.math.*;
	import away3d.core.utils.*;
	import away3d.sprites.*;
	
	import flash.display.*;
	import flash.utils.*;
	
	public class DirSpriteProjector extends AbstractProjector implements IPrimitiveProvider
	{
		private var _dirsprite:DirSprite2D;
		private var _vertices:Array;
		private var _vertex:Vertex;
		private var _bitmaps:Dictionary;
		private var _center:Vertex;
		private var _screenVertex:ScreenVertex;
		private var _persp:Number;
		private var _drawScaledBitmap:DrawScaledBitmap;
		
		public override function primitives(view:View3D, viewTransform:Matrix3D, consumer:IPrimitiveConsumer):void
		{
        	super.primitives(view, viewTransform, consumer);
        	
			_dirsprite = source as DirSprite2D;
			
			if (!_dirsprite)
				Debug.error("DirSpriteProjector must process a DirSprite2D object");
			
			_vertices = _dirsprite.vertices;
			_bitmaps = _dirsprite.bitmaps;
			
            if (_vertices.length == 0)
                return;
                
            var minz:Number = Infinity;
            var bitmap:BitmapData = null;
            
            for each (_vertex in _vertices) {
        		
				if (!(_screenVertex = primitiveDictionary[_vertex]))
					_screenVertex = primitiveDictionary[_vertex] = new ScreenVertex();
				
                view.camera.project(viewTransform, _vertex, _screenVertex);
                var z:Number = _screenVertex.z;
                
                if (z < minz) {
                    minz = z;
                    bitmap = _bitmaps[_vertex];
                }
            }
			
            if (bitmap == null)
                return;
            
            _center = _dirsprite.center;
            
			if (!(_screenVertex = primitiveDictionary[_center]))
				_screenVertex = primitiveDictionary[_center] = new ScreenVertex();
            
            view.camera.project(viewTransform, _center, _screenVertex);
            
            if (!_screenVertex.visible)
                return;
                
            _persp = view.camera.zoom / (1 + _screenVertex.z / view.camera.focus);
            _screenVertex.z += _dirsprite.deltaZ;
            
            if (!(_drawScaledBitmap = primitiveDictionary[_dirsprite])) {
				_drawScaledBitmap = primitiveDictionary[_dirsprite] = new DrawScaledBitmap();
	            _drawScaledBitmap.screenvertex = _screenVertex;
	            _drawScaledBitmap.source = _dirsprite;
			}
			
            _drawScaledBitmap.smooth = _dirsprite.smooth;
            _drawScaledBitmap.bitmap = bitmap;
            _drawScaledBitmap.scale = _persp*_dirsprite.scaling;
            _drawScaledBitmap.rotation = _dirsprite.rotation;
            _drawScaledBitmap.calc();
            
            consumer.primitive(_drawScaledBitmap);
		}
		
		public function clone():IPrimitiveProvider
		{
			return new DirSpriteProjector();
		}
	}
}