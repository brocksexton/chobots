package away3d.core.traverse
{
	import away3d.cameras.Camera3D;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.light.*;
	import away3d.core.math.*;
	import away3d.core.project.*;
	import away3d.core.render.*;
	
	import flash.utils.*;
	
    /**
    * Traverser that resolves the transform tree in a scene, ready for rendering.
    */
    public class ProjectionTraverser extends Traverser
    {
        private var _view:View3D;
        private var _mesh:Mesh;
        private var _camera:Camera3D;
        private var _cameraview:Matrix3D;
		private var _cameraviewtransforms:Dictionary;
		
		/**
		 * Defines the view being used.
		 */
		public function get view():View3D
		{
			return _view;
		}
		public function set view(val:View3D):void
		{
			_view = val;
			_camera = _view.camera;
            _cameraview = _camera.view;
            _cameraviewtransforms = _camera.viewTransforms;
//			if (_view.statsOpen)
//				_view.statsPanel.clearObjects();
		}
		    	
		/**
		 * Creates a new <code>ProjectionTraverser</code> object.
		 */
        public function ProjectionTraverser()
        {
        }
        
		/**
		 * @inheritDoc
		 */
        public override function match(node:Object3D):Boolean
        {
        	//check if node is visible
            if (!node.visible)
                return false;
            
            //compute viewTransform matrix
            _camera.createViewTransform(node).multiply(_cameraview, node.sceneTransform);
            
            //check which LODObject is visible
            if (node is ILODObject)
                return (node as ILODObject).matchLOD(_camera);
            
            return true;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function enter(node:Object3D):void
        {
//        	if (_view.statsOpen && node is Mesh)
//        		_view.statsPanel.addObject(node as Mesh);
        }
        
        public override function apply(node:Object3D):void
        {
            if (node.projector is ConvexBlockProjector)
                (node.projector as ConvexBlockProjector).blockers(_view, _camera.viewTransforms[node], _view.blockerarray);
            
        	//add to scene meshes dictionary
            if ((_mesh = node as Mesh))
            	_view.scene.meshes[node] = node;
        }
        
        public override function leave(node:Object3D):void
        {
            //update object
            node.updateObject();
        }
    }
}
