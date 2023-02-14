package away3d.core.traverse
{
	import away3d.containers.*;
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.light.*;
	import away3d.core.math.*;
	import away3d.core.render.*;
    

    /**
    * Traverser that gathers drawing primitives to render the scene.
    */
    public class PrimitiveTraverser extends Traverser
    {
    	use namespace arcane;
    	
    	private var _view:View3D;
    	private var _viewTransform:Matrix3D;
    	private var _consumer:IPrimitiveConsumer;
    	private var _mouseEnabled:Boolean;
    	private var _mouseEnableds:Array;
		private var _light:ILightProvider;
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
			_mouseEnabled = true;
			_mouseEnableds = [];
		}
		    	
		/**
		 * Creates a new <code>PrimitiveTraverser</code> object.
		 */
        public function PrimitiveTraverser()
        {
        }
        
		/**
		 * @inheritDoc
		 */
		public override function match(node:Object3D):Boolean
        {
            if (!node.visible)
                return false;
            if (node is ILODObject)
                return (node as ILODObject).matchLOD(_view.camera);
            return true;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function enter(node:Object3D):void
        {
        	_mouseEnableds.push(_mouseEnabled);
        }
        
		/**
		 * @inheritDoc
		 */
        public override function apply(node:Object3D):void
        {
        	if (node.session.updated) {
	        	_viewTransform = _view.camera.viewTransforms[node];
	        	_consumer = node.session.getConsumer(_view);
	        	
	        	if (node.projector)
	            	node.projector.primitives(_view, _viewTransform, _consumer);
	            
	            if (node.debugbb && node.debugBoundingBox.visible) {
	            	node.debugBoundingBox._session = node.session;
	            	node.debugBoundingBox.projector.primitives(_view, _viewTransform, _consumer);
	            }
	            	
	            if (node.debugbs && node.debugBoundingSphere.visible) {
	            	node.debugBoundingSphere._session = node.session;
	            	node.debugBoundingSphere.projector.primitives(_view, _viewTransform, _consumer);
	            }
	            
	            if (node is ILightProvider) {
	            	_light = node as ILightProvider;
	            	if (_light.debug)
	            		_light.debugPrimitive.projector.primitives(_view, _viewTransform, _consumer);
	            }
	        }
	        
            _mouseEnabled = node._mouseEnabled = (_mouseEnabled && node.mouseEnabled);
        }
        
		/**
		 * @inheritDoc
		 */
        public override function leave(node:Object3D):void
        {
        	_mouseEnabled = _mouseEnableds.pop();
        }

    }
}
