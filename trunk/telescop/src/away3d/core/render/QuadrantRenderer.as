package away3d.core.render
{
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.clip.*;
	import away3d.core.draw.*;
	import away3d.core.filter.*;
	import away3d.core.light.*;
	import away3d.core.stats.*;
	import away3d.core.traverse.*;
    

    /** Renderer that uses quadrant tree for storing and operating drawing primitives. Quadrant tree speeds up all proximity based calculations. */
    public class QuadrantRenderer implements IPrimitiveConsumer, IRenderer
    {
        private var _qdrntfilters:Array;
        private var _root:PrimitiveQuadrantTreeNode;
		private var _rect:RectangleClipping;
		private var _center:Array;
		private var _result:Array;
		private var _except:Object3D;
		private var _minX:Number;
		private var _minY:Number;
		private var _maxX:Number;
		private var _maxY:Number;
		private var _child:DrawPrimitive;
		private var _children:Array;
		private var i:int;
		private var _primitives:Array;
        private var _view:View3D;
        private var _scene:Scene3D;
        private var _camera:Camera3D;
        private var _clip:Clipping;
        private var _blockers:Array;
		private var _filter:IPrimitiveQuadrantFilter;
		
		private function getList(node:PrimitiveQuadrantTreeNode):void
        {
            if (node.onlysourceFlag && _except == node.onlysource)
                return;
			
            if (_minX < node.xdiv)
            {
                if (node.lefttopFlag && _minY < node.ydiv)
	                getList(node.lefttop);
	            
                if (node.leftbottomFlag && _maxY > node.ydiv)
                	getList(node.leftbottom);
            }
            
            if (_maxX > node.xdiv)
            {
                if (node.righttopFlag && _minY < node.ydiv)
                	getList(node.righttop);
                
                if (node.rightbottomFlag && _maxY > node.ydiv)
                	getList(node.rightbottom);
                
            }
            
            _children = node.center;
            if (_children != null) {
                i = _children.length;
                while (i--)
                {
                	_child = _children[i];
                    if ((_except == null || _child.source != _except) && _child.maxX > _minX && _child.minX < _maxX && _child.maxY > _minY && _child.minY < _maxY)
                        _result.push(_child);
                }
            }           
        }
        
        private function getParent(node:PrimitiveQuadrantTreeNode = null):void
        {
        	node = node.parent;
        	
            if (node == null || (node.onlysourceFlag && _except == node.onlysource))
                return;

            _children = node.center;
            if (_children != null) {
                i = _children.length;
                while (i--)
                {
                	_child = _children[i];
                    if ((_except == null || _child.source != _except) && _child.maxX > _minX && _child.minX < _maxX && _child.maxY > _minY && _child.minY < _maxY)
                        _result.push(_child);
                }
            }
            getParent(node);
        }
		
		/**
		 * Defines the array of filters to be used on the drawing primitives.
		 */
		public function get filters():Array
		{
			return _qdrntfilters;
		}
		
		public function set filters(val:Array):void
		{
			_qdrntfilters = val;
		}
		
		/**
		 * Creates a new <code>QuadrantRenderer</code> object.
		 *
		 * @param	filters	[optional]	An array of filters to use on projected drawing primitives before rendering them to screen.
		 */
        public function QuadrantRenderer(...filters)
        {
            _qdrntfilters = filters;
        }
		
		/**
		 * @inheritDoc
		 */
        public function primitive(pri:DrawPrimitive):void
        {
            if (_clip.check(pri))
            {
                _root.push(pri);
            }
        }
        
        /**
        * removes a drawing primitive from the quadrant tree.
        * 
        * @param	pri	The drawing primitive to remove.
        */
        public function remove(pri:DrawPrimitive):void
        {
        	_center = pri.quadrant.center;
        	_center.splice(_center.indexOf(pri), 1);
        }
		
		/**
		 * Returns an array containing all primiives overlapping the specifed primitive's quadrant.
		 * 
		 * @param	pri					The drawing primitive to check.
		 * @param	ex		[optional]	Excludes primitives that are children of the 3d object.
		 * @return						An array of drawing primitives.
		 */
        public function get(pri:DrawPrimitive, ex:Object3D = null):Array
        {
        	_result = [];
                    
			_minX = pri.minX;
			_minY = pri.minY;
			_maxX = pri.maxX;
			_maxY = pri.maxY;
			_except = ex;
			
            getList(pri.quadrant);
            getParent(pri.quadrant);
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
                    
			_minX = -1000000;
			_minY = -1000000;
			_maxX = 1000000;
			_maxY = 1000000;
			_except = null;
			
            getList(_root);
            
            return _result;
        }
        
        public function clear(view:View3D):void
        {
        	_primitives = [];
			_scene = view.scene;
			_camera = view.camera;
			_clip = view.clip;
			
			_rect = _clip.asRectangleClipping();
			if (!_root)
				_root = new PrimitiveQuadrantTreeNode((_rect.minX + _rect.maxX)/2, (_rect.minY + _rect.maxY)/2, _rect.maxX - _rect.minX, _rect.maxY - _rect.minY, 0);
			else
				_root.reset((_rect.minX + _rect.maxX)/2, (_rect.minY + _rect.maxY)/2, _rect.maxX - _rect.minX, _rect.maxY - _rect.minY);	
        }
        
        public function render(view:View3D):void
        {
			
        	//filter primitives array
			for each (_filter in _qdrntfilters)
        		_filter.filter(this, _scene, _camera, _clip);
        	
    		// render all primitives
            _root.render(-Infinity);
        }
        
		/**
		 * @inheritDoc
		 */
        public function toString():String
        {
            return "Quadrant ["+ _qdrntfilters.join("+") + "]";
        }
        
        public function clone():IPrimitiveConsumer
        {
        	var renderer:QuadrantRenderer = new QuadrantRenderer();
        	renderer.filters = filters;
        	return renderer;
        }
    }
}
