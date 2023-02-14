package away3d.core.base
{
    import away3d.core.*;
    import away3d.core.draw.*;
    import away3d.core.utils.*;
    import away3d.events.*;
    import away3d.materials.*;
    
    import flash.events.Event;
    
	 /**
	 * Dispatched when the material of the segment changes.
	 * 
	 * @eventType away3d.events.FaceEvent
	 */
	[Event(name="materialchanged",type="away3d.events.FaceEvent")]
	
    /**
    * A line element used in the wiremesh and mesh object
    * 
    * @see away3d.core.base.WireMesh
    * @see away3d.core.base.Mesh
    */
    public class Segment extends Element
    {
        use namespace arcane;
		/** @private */
        arcane var _v0:Vertex;
		/** @private */
        arcane var _v1:Vertex;
		/** @private */
        arcane var _material:ISegmentMaterial;
		/** @private */
        //arcane var _ds:DrawSegment = new DrawSegment();
		/** @private */
        arcane function notifyMaterialChange():void
        {
            if (!hasEventListener(SegmentEvent.MATERIAL_CHANGED))
                return;

            if (_materialchanged == null)
                _materialchanged = new SegmentEvent(SegmentEvent.MATERIAL_CHANGED, this);
                
            dispatchEvent(_materialchanged);
        }
        
        private var _materialchanged:SegmentEvent;
		
		//TODO: simplify vertex changed events
		/*
        private function onVertexChange(event:Event):void
        {
            notifyVertexChange();
        }
		*/
		
        private function onVertexValueChange(event:Event):void
        {
            notifyVertexValueChange();
        }
		
		/**
		 * Returns an array of vertex objects that are used by the segment.
		 */
        public override function get vertices():Array
        {
            return [_v0, _v1];
        }
		
		/**
		 * Defines the v0 vertex of the segment.
		 */
        public function get v0():Vertex
        {
            return _v0;
        }

        public function set v0(value:Vertex):void
        {
            if (value == _v0)
                return;

            if (_v0 != null)
                if (_v0 != _v1)
                    _v0.removeOnChange(onVertexValueChange);

            _v0 = value;

            if (_v0 != null)
                if (_v0 != _v1)
                    _v0.addOnChange(onVertexValueChange);

            notifyVertexChange();
        }
		
		/**
		 * Defines the v1 vertex of the segment.
		 */
        public function get v1():Vertex
        {
            return _v1;
        }

        public function set v1(value:Vertex):void
        {
            if (value == _v1)
                return;

            if (_v1 != null)
                if (_v1 != _v0)
                    _v1.removeOnChange(onVertexValueChange);

            _v1 = value;

            if (_v1 != null)
                if (_v1 != _v0)
                    _v1.addOnChange(onVertexValueChange);

            notifyVertexChange();
        }
		
		/**
		 * Defines the material of the segment.
		 */
        public function get material():ISegmentMaterial
        {
            return _material;
        }

        public function set material(value:ISegmentMaterial):void
        {
            if (value == _material)
                return;

            _material = value;

            notifyMaterialChange();
        }
		
		/**
		 * Returns the squared bounding radius of the face.
		 */
        public override function get radius2():Number
        {
            var rv0:Number = _v0._x*_v0._x + _v0._y*_v0._y + _v0._z*_v0._z;
            var rv1:Number = _v1._x*_v1._x + _v1._y*_v1._y + _v1._z*_v1._z;

            if (rv0 > rv1)
                return rv0;
            else
                return rv1;
        }
        
    	/**
    	 * Returns the maximum x value of the segment
    	 * 
    	 * @see		away3d.core.base.Vertex#x
    	 */
        public override function get maxX():Number
        {
            if (_v0._x > _v1._x)
                return _v0._x;
            else
                return _v1._x;
        }
        
    	/**
    	 * Returns the minimum x value of the face
    	 * 
    	 * @see		away3d.core.base.Vertex#x
    	 */
        public override function get minX():Number
        {
            if (_v0._x < _v1._x)
                return _v0._x;
            else
                return _v1._x;
        }
        
    	/**
    	 * Returns the maximum y value of the segment
    	 * 
    	 * @see		away3d.core.base.Vertex#y
    	 */
        public override function get maxY():Number
        {
            if (_v0._y > _v1._y)
                return _v0._y;
            else
                return _v1._y;
        }
        
    	/**
    	 * Returns the minimum y value of the face
    	 * 
    	 * @see		away3d.core.base.Vertex#y
    	 */
        public override function get minY():Number
        {
            if (_v0._y < _v1._y)
                return _v0._y;
            else
                return _v1._y;
        }
        
    	/**
    	 * Returns the maximum z value of the segment
    	 * 
    	 * @see		away3d.core.base.Vertex#z
    	 */
        public override function get maxZ():Number
        {
            if (_v0._z > _v1._z)
                return _v0._z;
            else
                return _v1._z;
        }
        
    	/**
    	 * Returns the minimum y value of the face
    	 * 
    	 * @see		away3d.core.base.Vertex#y
    	 */
        public override function get minZ():Number
        {
            if (_v0._z < _v1._z)
                return _v0._z;
            else
                return _v1._z;
        }
    	
		/**
		 * Creates a new <code>Segment</code> object.
		 *
		 * @param	v0						The first vertex object of the segment
		 * @param	v1						The second vertex object of the segment
		 * @param	material	[optional]	The material used by the segment to render
		 */
        public function Segment(v0:Vertex, v1:Vertex, material:ISegmentMaterial = null)
        {
            this.v0 = v0;
            this.v1 = v1;
            this.material = material;
            
            vertexDirty = true;
        }
		
		/**
		 * Default method for adding a materialchanged event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function addOnMaterialChange(listener:Function):void
        {
            addEventListener(SegmentEvent.MATERIAL_CHANGED, listener, false, 0, true);
        }
		
		/**
		 * Default method for removing a materialchanged event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function removeOnMaterialChange(listener:Function):void
        {
            removeEventListener(SegmentEvent.MATERIAL_CHANGED, listener, false);
        }
    }
}
