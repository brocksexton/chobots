package away3d.animators.skin
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.math.*;
	
    public class SkinVertex
    {
    	private var _i:int;
    	private var _skinController:SkinController;
    	private var _position:Number3D = new Number3D();
		private var _sceneTransform:Matrix3D = new Matrix3D();
		
		public var baseVertex:Vertex;
        public var skinnedVertex:Vertex;
        public var weights:Array = new Array();
        public var controllers:Array = new Array();
		
        public function SkinVertex(vertex:Vertex)
        {
            skinnedVertex = vertex;
            baseVertex = vertex.clone();
        }

        public function update() : void
        {
        	var updated:Boolean = false;
        	for each (_skinController in controllers)
        		updated = updated || _skinController.updated;
        	
        	if (!updated)
        		return;
        	
        	//reset values
            skinnedVertex.reset();
            
            _i = weights.length;
            while (_i--) {
				_position.transform(baseVertex.position, (controllers[_i] as SkinController).sceneTransform);
				_position.scale(_position, weights[_i]);
				skinnedVertex.add(_position);
            }
        }
    }
}
