package away3d.core.project
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.math.*;
	import away3d.core.utils.*;
	import away3d.sprites.*;
	
	public class SpriteProjector extends AbstractProjector implements IPrimitiveProvider
	{
		private var _sprite:Sprite2D;
		private var _center:Vertex;
		private var _screenVertex:ScreenVertex;
		private var _persp:Number;
		private var _drawScaledBitmap:DrawScaledBitmap;
		
		public override function primitives(view:View3D, viewTransform:Matrix3D, consumer:IPrimitiveConsumer):void
		{
        	super.primitives(view, viewTransform, consumer);
        	
			_sprite = source as Sprite2D;
			
			if (!_sprite)
				Debug.error("Sprite2D must process a Sprite2D object");
			
			_center = _sprite.center;
			
			if (!(_screenVertex = primitiveDictionary[_center]))
				_screenVertex = primitiveDictionary[_center] = new ScreenVertex();
            
            view.camera.project(viewTransform, _center, _screenVertex);
            
            if (!_screenVertex.visible)
                return;
                
            _persp = view.camera.zoom / (1 + _screenVertex.z / view.camera.focus);          
            _screenVertex.z += _sprite.deltaZ;
            
            if (!(_drawScaledBitmap = primitiveDictionary[_sprite])) {
				_drawScaledBitmap = primitiveDictionary[_sprite] = new DrawScaledBitmap();
	            _drawScaledBitmap.screenvertex = _screenVertex;
	            _drawScaledBitmap.source = _sprite;
			}
            _drawScaledBitmap.screenvertex = _screenVertex;
            _drawScaledBitmap.smooth = _sprite.smooth;
            _drawScaledBitmap.bitmap = _sprite.bitmap;
            _drawScaledBitmap.scale = _persp*_sprite.scaling;
            _drawScaledBitmap.rotation = _sprite.rotation;
            _drawScaledBitmap.calc();
            
            consumer.primitive(_drawScaledBitmap);
		}
		
		public function clone():IPrimitiveProvider
		{
			return new DirSpriteProjector();
		}
	}
}