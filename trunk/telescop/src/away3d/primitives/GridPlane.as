package away3d.primitives
{
	import away3d.core.*;
    import away3d.core.base.*;
    import away3d.core.utils.*;
    
    /**
    * Creates a 3d grid primitive.
    */ 
    public class GridPlane extends AbstractWirePrimitive
    {
    	use namespace arcane
    	
    	private var _width:Number;
        private var _height:Number;
        private var _segmentsW:int;
        private var _segmentsH:int;
        private var _yUp:Boolean;
        
        private function buildPlane(width:Number, height:Number, segmentsW:int, segmentsH:int, yUp:Boolean):void
        {
        	var i:int;
        	var j:int;
        	
        	if (yUp) {
	            for (i = 0; i <= segmentsW; i++)
	                addSegment(createSegment(createVertex((i/segmentsW - 0.5)*width, 0, -0.5*height), createVertex((i/segmentsW - 0.5)*width, 0, 0.5*height)));
	
	            for (j = 0; j <= segmentsH; j++)
	                addSegment(createSegment(createVertex(-0.5*width, 0, (j/segmentsH - 0.5)*height), createVertex(0.5*width, 0, (j/segmentsH - 0.5)*height)));
        	} else {
        		for (i = 0; i <= segmentsW; i++)
	                addSegment(createSegment(createVertex((i/segmentsW - 0.5)*width, -0.5*height, 0), createVertex((i/segmentsW - 0.5)*width, 0.5*height, 0)));
	
	            for (j = 0; j <= segmentsH; j++)
	                addSegment(createSegment(createVertex(-0.5*width, (j/segmentsH - 0.5)*height, 0), createVertex(0.5*width, (j/segmentsH - 0.5)*height, 0)));
	       
        	}
		}
		
    	/**
    	 * Defines the width of the grid. Defaults to 100.
    	 */
    	public function get width():Number
    	{
    		return _width;
    	}
    	
    	public function set width(val:Number):void
    	{
    		if (_width == val)
    			return;
    		
    		_width = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the height of the grid. Defaults to 100.
    	 */
    	public function get height():Number
    	{
    		return _height;
    	}
    	
    	public function set height(val:Number):void
    	{
    		if (_height == val)
    			return;
    		
    		_height = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of horizontal segments that make up the grid. Defaults to 1.
    	 */
    	public function get segmentsW():Number
    	{
    		return _segmentsW;
    	}
    	
    	public function set segmentsW(val:Number):void
    	{
    		if (_segmentsW == val)
    			return;
    		
    		_segmentsW = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of vertical segments that make up the grid. Defaults to 1.
    	 */
    	public function get segmentsH():Number
    	{
    		return _segmentsH;
    	}
    	
    	public function set segmentsH(val:Number):void
    	{
    		if (_segmentsH == val)
    			return;
    		
    		_segmentsH = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines whether the coordinates of the grid points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
    	 */
    	public function get yUp():Boolean
    	{
    		return _yUp;
    	}
    	
    	public function set yUp(val:Boolean):void
    	{
    		if (_yUp == val)
    			return;
    		
    		_yUp = val;
    		_primitiveDirty = true;
    	}
		
		/**
		 * Creates a new <code>GridPlane</code> object.
		 *
		 * @param	init			[optional]	An initialisation object for specifying default instance properties.
		 */
        public function GridPlane(init:Object = null)
        {
            super(init);

            _width = ini.getNumber("width", 100, {min:0});
            _height = ini.getNumber("height", 100, {min:0});
            var segments:int = ini.getInt("segments", 1, {min:1});
            _segmentsW = ini.getInt("segmentsW", segments, {min:1});
            _segmentsH = ini.getInt("segmentsH", segments, {min:1});
    		_yUp = ini.getBoolean("yUp", true);
    		
			buildPlane(_width, _height, _segmentsW, _segmentsH, _yUp);
			
	   		type = "GridPlane";
        	url = "primitive";
        }
		
		/**
		 * @inheritDoc
		 */
    	public override function buildPrimitive():void
    	{
    		super.buildPrimitive();
    		
            buildPlane(_width, _height, _segmentsW, _segmentsH, _yUp);
    	}
    }
}
