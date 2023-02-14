package away3d.core.draw
{
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.core.block.*;
	import away3d.core.clip.*;
	import away3d.core.filter.*;
	import away3d.core.render.*;
	
	import flash.utils.Dictionary;
    
    //TODO: properly implement a volume block renderer.
    /**
    * Volume block tree for storing drawing primitives
    */
    public class PrimitiveVolumeBlock implements IPrimitiveConsumer
    {
        private var _blocks:Dictionary = new Dictionary(true);
        private var _block:PrimitiveVolumeBlockNode;
        private var _root:PrimitiveVolumeBlockNode = new PrimitiveVolumeBlockNode(null);
        private var _clip:Clipping;
        private var _result:Array;
		private var _primitive:DrawPrimitive;
        private var _scene:Scene3D;
        private var _camera:Camera3D;
		private var _filter:IPrimitiveFilter;
        
		/**
		 * @inheritDoc
		 */
        public function primitive(pri:DrawPrimitive):void
        {
            if (_clip.check(pri))
            {
                if (pri.source == null) {
                    _root.push(pri);
                } else {
                    _block = _blocks[pri.source];
                    
                    if (_block == null)
                        _block = _blocks[pri.source] = new PrimitiveVolumeBlockNode(pri.source);
                    
                    _block.push(pri);
                }
            }
        }
        
        /**
        * removes a drawing primitive from the volume block.
        * 
        * @param	pri	The drawing primitive to remove.
        */
        public function remove(pri:DrawPrimitive):void
        {
            if (pri.source == null) {
                _root.remove(pri);
            } else {
                _block = list[pri.source];
                if (_block == null)
                    throw new Error("Can't remove");
                _block.remove(pri);
            }
        }
		
		/**
		 * A list of volume blocks contained in the scene.
		 * 
		 * @return	An array containing all volume blocks in the scene.
		 */
        public function blocks():Array
        {   
            _result = _root.list.length > 0 ? [_root] : [];
            for each (_block in _blocks)
                _result.push(_block);
            return _result;
        }
		
		/**
		 * A list of primitives that have been clipped.
		 * 
		 * @return	An array containing the primitives to be rendered.
		 */
        public function list():Array
        {   
            _result = [];
            for each (var rpri:DrawPrimitive in _root)
                if (rpri.screenZ != Infinity)
                    _result.push(rpri);
            _root = null;
            
            for each (_block in _blocks)
            {
                var list:Array = _block.list;
                for each (var pri:DrawPrimitive in list)
                    if (pri.screenZ != Infinity)
                        _result.push(pri);
                _block.list = null;
            }
            return _result;
        }

        public function getTouching(target:PrimitiveVolumeBlockNode):Array
        {   
            _result = [];
            for each (var block:PrimitiveVolumeBlockNode in blocks)
            {
                if (block.minZ > target.maxZ)
                    continue;
                if (block.maxZ < target.minZ)
                    continue;
                if (block.minX > target.maxX)
                    continue;
                if (block.maxX < target.minX)
                    continue;
                if (block.minY > target.maxY)
                    continue;
                if (block.maxY < target.minY)
                    continue;

                _result.push(block);
            }
            return _result;
        }
                
        public function clear(view:View3D):void
        {
			_scene = view.scene;
			_camera = view.camera;
			_clip = view.clip;
        	_result = [];
        }
        
        public function clone():IPrimitiveConsumer
        {
        	return new PrimitiveVolumeBlock();
        }
        
        public function render(view:View3D):void
        {
    		// render all primitives
        }
		
		public function filter(filters:Array):void
		{
			for each (_filter in filters)
        		_result = _filter.filter(_result, _scene, _camera, _clip);
		}
    }
}
