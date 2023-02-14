package away3d.core.project
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.math.*;
	import away3d.core.utils.*;
	import away3d.sprites.*;
	
	import flash.display.*;
	
	public class MovieClipSpriteProjector extends AbstractProjector implements IPrimitiveProvider
	{
		private var _movieClipSprite:MovieClipSprite;
		private var _movieclip:DisplayObject;
		private var _child:Object3D;
		private var _displayObject:DisplayObject;
		private var _center:Vertex;
		private var _screenVertex:ScreenVertex;
		private var _persp:Number;
		private var _drawDisplayObject:DrawDisplayObject;
		
		public override function primitives(view:View3D, viewTransform:Matrix3D, consumer:IPrimitiveConsumer):void
		{
			super.primitives(view, viewTransform, consumer);
			
			_movieClipSprite = source as MovieClipSprite;
			
			if (!_movieClipSprite)
				Debug.error("MovieClipSpriteProjector must process a MovieClipSprite object");
			
			_movieclip = _movieClipSprite.movieclip;
			_center = _movieClipSprite.center;
			
			if (!(_screenVertex = primitiveDictionary[_center]))
				_screenVertex = primitiveDictionary[_center] = new ScreenVertex();
            
            view.camera.project(viewTransform, _center, _screenVertex);
			
            _persp = view.camera.zoom / (1 + _screenVertex.z / view.camera.focus);
            
            _screenVertex.z += _movieClipSprite.deltaZ;
            _screenVertex.x -= _movieclip.width/2;
            _screenVertex.y -= _movieclip.height/2;
			 
			if(_movieClipSprite.rescale)
				_movieclip.scaleX = _movieclip.scaleY = _persp*_movieClipSprite.scaling;
			
			if (!(_drawDisplayObject = primitiveDictionary[_child])) {
				_drawDisplayObject = primitiveDictionary[_child] = new DrawDisplayObject();
				_drawDisplayObject.view = view;
				_drawDisplayObject.screenvertex = _screenVertex;
			}
			
			_drawDisplayObject.session = _movieClipSprite.session;
			_drawDisplayObject.displayobject = _movieclip;
			_drawDisplayObject.calc();
			
            consumer.primitive(_drawDisplayObject);
		}
		
		public function clone():IPrimitiveProvider
		{
			return new SessionProjector();
		}
	}
}