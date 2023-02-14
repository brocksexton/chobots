package away3d.primitives
{
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.utils.*;
	import away3d.materials.*;
    
    /**
    * Creates a 3d plane primitive.
    */ 
    public class Plane extends AbstractPrimitive
    {
    	use namespace arcane
    	
        private var grid:Array;
    	private var _width:Number;
        private var _height:Number;
        private var _segmentsW:int;
        private var _segmentsH:int;
        private var _yUp:Boolean;
        
        private function buildPlane(width:Number, height:Number, segmentsW:int, segmentsH:int, yUp:Boolean):void
        {
            var i:int;
            var j:int;

            grid = new Array(segmentsW+1);
            for (i = 0; i <= segmentsW; i++)
            {
                grid[i] = new Array(segmentsH+1);
                for (j = 0; j <= segmentsH; j++) {
                	if (yUp)
                    	grid[i][j] = createVertex((i / segmentsW - 0.5) * width, 0, (j / segmentsH - 0.5) * height);
                    else
                    	grid[i][j] = createVertex((i / segmentsW - 0.5) * width, (j / segmentsH - 0.5) * height, 0);
                }
            }

            for (i = 0; i < segmentsW; i++)
                for (j = 0; j < segmentsH; j++)
                {
                    var a:Vertex = grid[i  ][j  ]; 
                    var b:Vertex = grid[i+1][j  ];
                    var c:Vertex = grid[i  ][j+1]; 
                    var d:Vertex = grid[i+1][j+1];

                    var uva:UV = createUV(i     / segmentsW, j     / segmentsH);
                    var uvb:UV = createUV((i+1) / segmentsW, j     / segmentsH);
                    var uvc:UV = createUV(i     / segmentsW, (j+1) / segmentsH);
                    var uvd:UV = createUV((i+1) / segmentsW, (j+1) / segmentsH);

                    addFace(createFace(a, b, c, null, uva, uvb, uvc));
                    addFace(createFace(d, c, b, null, uvd, uvc, uvb));
                }
        }
		
    	/**
    	 * Defines the width of the plane. Defaults to 100, or the width of the uv material (if one is applied).
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
    	 * Defines the height of the plane. Defaults to 100, or the height of the uv material (if one is applied).
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
    	 * Defines the number of horizontal segments that make up the plane. Defaults to 1.
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
    	 * Defines the number of vertical segments that make up the plane. Defaults to 1.
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
    	 * Defines whether the coordinates of the plane points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
		 * Creates a new <code>Plane</code> object.
		 *
		 * @param	init			[optional]	An initialisation object for specifying default instance properties.
		 */
        public function Plane(init:Object = null)
        {
            super(init);

            _width = ini.getNumber("width", 100, {min:0});
            _height = ini.getNumber("height", 100, {min:0});
            var segments:int = ini.getInt("segments", 1, {min:1});
            _segmentsW = ini.getInt("segmentsW", segments, {min:1});
            _segmentsH = ini.getInt("segmentsH", segments, {min:1});
    		_yUp = ini.getBoolean("yUp", true);

            if (width*height == 0)
            {
                if (material is IUVMaterial)
                {
                    var uvm:IUVMaterial = material as IUVMaterial;
                    if (width == 0)
                        width = uvm.width;
                    if (height == 0)
                        height = uvm.height;
                }
                else
                {
                    width = 100;
                    height = 100;
                }
            }
			
			buildPlane(_width, _height, _segmentsW, _segmentsH, _yUp);
			
			type = "Plane";
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
