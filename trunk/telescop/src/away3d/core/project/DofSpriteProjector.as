package away3d.core.project
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.math.*;
	import away3d.core.utils.*;
	import away3d.sprites.*;
	
	public class DofSpriteProjector extends AbstractProjector implements IPrimitiveProvider
	{
		private var _dofsprite:DofSprite2D;
		private var _dofcache:DofCache;
		private var _center:Vertex;
		private var _screenVertex:ScreenVertex;
		private var _persp:Number;
		private var _drawScaledBitmap:DrawScaledBitmap;
		
		public override function primitives(view:View3D, viewTransform:Matrix3D, consumer:IPrimitiveConsumer):void
		{
        	super.primitives(view, viewTransform, consumer);
        	
			_dofsprite = source as DofSprite2D;
			
			if (!_dofsprite)
				Debug.error("DofSpriteProjector must process a DofSprite2D object");
			
			_center = _dofsprite.center;
			
			if (!(_screenVertex = primitiveDictionary[_center]))
				_screenVertex = primitiveDictionary[_center] = new ScreenVertex();
            
            view.camera.project(viewTransform, _center, _screenVertex);
            
            if (!_screenVertex.visible)
                return;
                
            _persp = view.camera.zoom / (1 + _screenVertex.z / view.camera.focus);          
            _screenVertex.z += _dofsprite.deltaZ;
            
            if (!(_drawScaledBitmap = primitiveDictionary[_dofsprite])) {
				_drawScaledBitmap = primitiveDictionary[_dofsprite] = new DrawScaledBitmap();
	            _drawScaledBitmap.screenvertex = _screenVertex;
	            _drawScaledBitmap.source = _dofsprite;
	            _dofcache = DofCache.getDofCache(_dofsprite.bitmap);
			}
            _drawScaledBitmap.screenvertex = _screenVertex;
            _drawScaledBitmap.smooth = _dofsprite.smooth;
            _drawScaledBitmap.bitmap = _dofcache.getBitmap(_screenVertex.z);
            _drawScaledBitmap.scale = _persp*_dofsprite.scaling;
            _drawScaledBitmap.rotation = _dofsprite.rotation;
            _drawScaledBitmap.calc();
            
            consumer.primitive(_drawScaledBitmap);
		}
		
		public function clone():IPrimitiveProvider
		{
			return new DirSpriteProjector();
		}
	}
}