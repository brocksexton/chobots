package away3d.primitives
{
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.utils.*;
    
    /**
    * Creates a 3d cone primitive.
    */ 
    public class Cone extends AbstractPrimitive
    {
    	use namespace arcane
    	
        private var grid:Array;
        private var jMin:int;
        private var _radius:Number;
        private var _height:Number;
        private var _segmentsW:int;
        private var _segmentsH:int;
        private var _openEnded:Boolean;
        private var _yUp:Boolean;
        
        private function buildCone(radius:Number, height:Number, segmentsW:int, segmentsH:int, openEnded:Boolean, yUp:Boolean):void
        {
            var i:int;
            var j:int;

            height /= 2;

            grid = new Array();
			
			
			if (!openEnded) {
				jMin = 1;
	            segmentsH += 1;
	            var bottom:Vertex = yUp? createVertex(0, -height, 0) : createVertex(0, 0, -height);
	            grid[0] = new Array(segmentsW);
	            for (i = 0; i < segmentsW; i++) 
	                grid[0][i] = bottom;
			} else {
				jMin = 0;
			}
			
            for (j = jMin; j < segmentsH; j++)  
            { 
                var z:Number = -height + 2 * height * (j-1) / (segmentsH-1);

                grid[j] = new Array(segmentsW);
                for (i = 0; i < segmentsW; i++) 
                { 
                    var verangle:Number = 2 * i / segmentsW * Math.PI;
                    var ringradius:Number = radius * (segmentsH-j)/(segmentsH-1);
                    var x:Number = ringradius * Math.sin(verangle);
                    var y:Number = ringradius * Math.cos(verangle);
                    
                    if (yUp)
                    	grid[j][i] = createVertex(y, z, x);
                    else
                    	grid[j][i] = createVertex(y, -x, z);
                }
            }

            var top:Vertex = yUp? createVertex(0, height, 0) : createVertex(0, 0, height);
            grid[segmentsH] = new Array(segmentsW);
            for (i = 0; i < segmentsW; i++) 
                grid[segmentsH][i] = top;

            for (j = 1; j <= segmentsH; j++) 
                for (i = 0; i < segmentsW; i++) 
                {
                    var a:Vertex = grid[j][i];
                    var b:Vertex = grid[j][(i-1+segmentsW) % segmentsW];
                    var c:Vertex = grid[j-1][(i-1+segmentsW) % segmentsW];
                    var d:Vertex = grid[j-1][i];
					
					var i2:int = i;
					if (i == 0) i2 = segmentsW;
					
                    var vab:Number = j / (segmentsH + 1);
                    var vcd:Number = (j-1) / (segmentsH + 1);
                    var uad:Number = i2 / segmentsW;
                    var ubc:Number = (i2-1) / segmentsW;
                    var uva:UV = createUV(uad,vab);
                    var uvb:UV = createUV(ubc,vab);
                    var uvc:UV = createUV(ubc,vcd);
                    var uvd:UV = createUV(uad,vcd);

                    if (j < segmentsH)
                        addFace(createFace(a,b,c, null, uva,uvb,uvc));
                    if (j > 1)                
                        addFace(createFace(a,c,d, null, uva,uvc,uvd));
                }
        }
        
    	/**
    	 * Defines the radius of the cone base. Defaults to 100.
    	 */
    	public function get radius():Number
    	{
    		return _radius;
    	}
    	
    	public function set radius(val:Number):void
    	{
    		if (_radius == val)
    			return;
    		
    		_radius = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the height of the cone. Defaults to 200.
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
    	 * Defines the number of horizontal segments that make up the cone. Defaults to 8.
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
    	 * Defines the number of vertical segments that make up the cone. Defaults to 1.
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
    	 * Defines whether the end of the cone is left open (true) or closed (false). Defaults to false.
    	 */
    	public function get openEnded():Boolean
    	{
    		return _openEnded;
    	}
    	
    	public function set openEnded(val:Boolean):void
    	{
    		if (_openEnded == val)
    			return;
    		
    		_openEnded = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines whether the coordinates of the cone points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
		 * Creates a new <code>Cone</code> object.
		 *
		 * @param	init			[optional]	An initialisation object for specifying default instance properties.
		 */
        public function Cone(init:Object = null)
        {
            super(init);

            _radius = ini.getNumber("radius", 100, {min:0});
            _height = ini.getNumber("height", 200, {min:0});
            _segmentsW = ini.getInt("segmentsW", 8, {min:3});
            _segmentsH = ini.getInt("segmentsH", 1, {min:1});
			_openEnded = ini.getBoolean("openEnded", false);
			_yUp = ini.getBoolean("yUp", true);
			
			buildCone(_radius, _height, _segmentsW, _segmentsH, _openEnded, _yUp);
			
            type = "Cone";
        	url = "primitive";
        }
        
		/**
		 * @inheritDoc
		 */
    	public override function buildPrimitive():void
    	{
    		super.buildPrimitive();
    		
            buildCone(_radius, _height, _segmentsW, _segmentsH, _openEnded, _yUp);
    	}
        
		/**
		 * Returns the vertex object specified by the grid position of the mesh.
		 * 
		 * @param	w	The horizontal position on the primitive mesh.
		 * @param	h	The vertical position on the primitive mesh.
		 */
        public function vertex(w:int, h:int):Vertex
        {
            return grid[h][w];
        }
    }
}