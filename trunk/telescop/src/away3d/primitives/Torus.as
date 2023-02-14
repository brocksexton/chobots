package away3d.primitives
{
	import away3d.core.*;
    import away3d.core.base.*;
    import away3d.core.utils.*;
    
    /**
    * Creates a 3d torus primitive.
    */ 
    public class Torus extends AbstractPrimitive
    {
    	use namespace arcane
    	
        private var grid:Array;
        private var _radius:Number;
        private var _tube:Number;
        private var _segmentsR:int;
        private var _segmentsT:int;
        private var _yUp:Boolean;
        
        private function buildTorus(radius:Number, tube:Number, segmentsR:int, segmentsT:int, yUp:Boolean):void
        {
            var i:int;
            var j:int;

            grid = new Array(segmentsR);
            for (i = 0; i < segmentsR; i++)
            {
                grid[i] = new Array(segmentsT);
                for (j = 0; j < segmentsT; j++)
                {
                    var u:Number = i / segmentsR * 2 * Math.PI;
                    var v:Number = j / segmentsT * 2 * Math.PI;
                    
                    if (yUp)
                    	grid[i][j] = createVertex((radius + tube*Math.cos(v))*Math.cos(u), tube*Math.sin(v), (radius + tube*Math.cos(v))*Math.sin(u));
                    else
                    	grid[i][j] = createVertex((radius + tube*Math.cos(v))*Math.cos(u), -(radius + tube*Math.cos(v))*Math.sin(u), tube*Math.sin(v));
                }
            }

            for (i = 0; i < segmentsR; i++)
                for (j = 0; j < segmentsT; j++)
                {
                    var ip:int = (i+1) % segmentsR;
                    var jp:int = (j+1) % segmentsT;
                    var a:Vertex = grid[i ][j]; 
                    var b:Vertex = grid[ip][j];
                    var c:Vertex = grid[i ][jp]; 
                    var d:Vertex = grid[ip][jp];

                    var uva:UV = createUV(i     / segmentsR, j     / segmentsT);
                    var uvb:UV = createUV((i+1) / segmentsR, j     / segmentsT);
                    var uvc:UV = createUV(i     / segmentsR, (j+1) / segmentsT);
                    var uvd:UV = createUV((i+1) / segmentsR, (j+1) / segmentsT);

                    addFace(createFace(a, b, c, null, uva, uvb, uvc));
                    addFace(createFace(d, c, b, null, uvd, uvc, uvb));
                }
        }
        
    	/**
    	 * Defines the overall radius of the torus. Defaults to 100.
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
    	 * Defines the tube radius of the torus. Defaults to 40.
    	 */
    	public function get tube():Number
    	{
    		return _tube;
    	}
    	
    	public function set tube(val:Number):void
    	{
    		if (_tube == val)
    			return;
    		
    		_tube = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of radial segments that make up the torus. Defaults to 8.
    	 */
    	public function get segmentsR():Number
    	{
    		return _segmentsR;
    	}
    	
    	public function set segmentsR(val:Number):void
    	{
    		if (_segmentsR == val)
    			return;
    		
    		_segmentsR = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of tubular segments that make up the torus. Defaults to 6.
    	 */
    	public function get segmentsT():Number
    	{
    		return _segmentsT;
    	}
    	
    	public function set segmentsT(val:Number):void
    	{
    		if (_segmentsT == val)
    			return;
    		
    		_segmentsT = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines whether the coordinates of the torus points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
		 * Creates a new <code>Torus</code> object.
		 *
		 * @param	init			[optional]	An initialisation object for specifying default instance properties.
		 */
        public function Torus(init:Object = null)
        {
            super(init);

            _radius = ini.getNumber("radius", 100, {min:0});
            _tube = ini.getNumber("tube", 40, {min:0, max:radius});
            _segmentsR = ini.getInt("segmentsR", 8, {min:3});
            _segmentsT = ini.getInt("segmentsT", 6, {min:3});
			_yUp = ini.getBoolean("yUp", true);
			
			buildTorus(_radius, _tube, _segmentsR, _segmentsT, _yUp);
			
			type = "Torus";
        	url = "primitive";
        }
        
		/**
		 * @inheritDoc
		 */
    	public override function buildPrimitive():void
    	{
    		super.buildPrimitive();
    		
            buildTorus(_radius, _tube, _segmentsR, _segmentsT, _yUp);
    	}
        
		/**
		 * Returns the vertex object specified by the grid position of the mesh.
		 * 
		 * @param	r	The radial position on the primitive mesh.
		 * @param	t	The tubular position on the primitive mesh.
		 */
        public function vertex(r:int, t:int):Vertex
        {
            return grid[t][r];
        }
    }
}
