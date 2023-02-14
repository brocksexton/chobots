package away3d.core.project
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.math.*;
	import away3d.core.utils.*;
	import away3d.materials.ISegmentMaterial;
	
	public class SegmentProjector extends AbstractProjector implements IPrimitiveProvider
	{
		private var _mesh:Mesh;
		private var _segmentMaterial:ISegmentMaterial;
		private var _vertex:Vertex;
		private var _screenVertex:ScreenVertex;
		private var _segment:Segment;
		private var _drawSegment:DrawSegment;
		
		public override function primitives(view:View3D, viewTransform:Matrix3D, consumer:IPrimitiveConsumer):void
		{
			super.primitives(view, viewTransform, consumer);
			
			_mesh = source as Mesh;
			
			if (!_mesh)
				Debug.error("SegmentProjector must process a Mesh object");
			
			_segmentMaterial = _mesh.material as ISegmentMaterial;
			
			if (!_segmentMaterial && _mesh.material)
				Debug.error("SegmentProjector mesh material must be an ISegmentMaterial object");
			
			for each (_vertex in _mesh.vertices) {
				if (!(_screenVertex = primitiveDictionary[_vertex]))
					_screenVertex = primitiveDictionary[_vertex] = new ScreenVertex();
				
				view.camera.project(viewTransform, _vertex, _screenVertex);
			}
			
            for each (_segment in _mesh.segments)
            {
            	if (!(_drawSegment = primitiveDictionary[_segment])) {
					_drawSegment = primitiveDictionary[_segment] = new DrawSegment();
	            	_drawSegment.view = view;
	            	_drawSegment.source = _mesh;
	            	_drawSegment.create = createDrawSegment;
            	}
            	
            	_drawSegment.v0 = primitiveDictionary[_segment.v0];
				_drawSegment.v1 = primitiveDictionary[_segment.v1];
    
                if (!_drawSegment.v0.visible)
                    continue;
				
                if (!_drawSegment.v1.visible)
                    continue;
				
                _drawSegment.calc();
				
                _drawSegment.material = _segment.material || _segmentMaterial;
				
                if (_drawSegment.material == null)
                    continue;
				
                if (!_drawSegment.material.visible)
                    continue;
                
                consumer.primitive(_drawSegment);
            }
		}
				
		public function clone():IPrimitiveProvider
		{
			return new SegmentProjector();
		}
	}
}