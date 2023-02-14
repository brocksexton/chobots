package away3d.core.draw
{
	import away3d.core.*;
    import away3d.core.render.*;
    import away3d.materials.*;

    /**
    * Line segment drawing primitive
    */
    public class DrawSegment extends DrawPrimitive
    {
    	use namespace arcane;
		/** @private */
		arcane function onepointcut(v01:ScreenVertex):Array
		{
            return [create(view, source, material, v0, v01), create(view, source, material, v01, v1)];
    	}
    	
    	private var focus:Number;  
        private var ax:Number;
        private var ay:Number;
        private var az:Number;
        private var bx:Number;
        private var by:Number;
        private var bz:Number;
        private var dx:Number;
        private var dy:Number;
        private var azf:Number;
        private var bzf:Number;
        private var faz:Number;
        private var fbz:Number;
        private var xfocus:Number;
        private var yfocus:Number;
        private var axf:Number;
        private var bxf:Number;
        private var ayf:Number;
        private var byf:Number;
        private var det:Number;
        private var db:Number;
        private var da:Number;
        
        private function distanceToCenter(x:Number, y:Number):Number
        {   
            var centerx:Number = (v0.x + v1.x) / 2;
            var centery:Number = (v0.y + v1.y) / 2;

            return Math.sqrt((centerx-x)*(centerx-x) + (centery-y)*(centery-y));
        }
        
		/**
		 * The v0 screenvertex of the segment primitive.
		 */
        public var v0:ScreenVertex;
		
		/**
		 * The v1 screenvertex of the segment primitive.
		 */
        public var v1:ScreenVertex;
		
				
		/**
		 * The screen length of the segment primitive.
		 */
        public var length:Number;
		
		/**
		 * The material of the segment primitive.
		 */
        public var material:ISegmentMaterial;
        
		/**
		 * @inheritDoc
		 */
        public override function clear():void
        {
            v0 = null;
            v1 = null;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function render():void
        {
            material.renderSegment(this);
        }
        
		/**
		 * @inheritDoc
		 */
        public override function contains(x:Number, y:Number):Boolean
        {   
            if (Math.abs(v0.x*(y - v1.y) + v1.x*(v0.y - y) + x*(v1.y - v0.y)) > 0.001*1000*1000)
                return false;

            if (distanceToCenter(x, y)*2 > length)
                return false;

            return true;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function getZ(x:Number, y:Number):Number
        {
            focus = view.camera.focus;
              
            ax = v0.x;
            ay = v0.y;
            az = v0.z;
            bx = v1.x;
            by = v1.y;
            bz = v1.z;

            if ((ax == x) && (ay == y))
                return az;

            if ((bx == x) && (by == y))
                return bz;

            dx = bx - ax;
            dy = by - ay;

            azf = az / focus;
            bzf = bz / focus;

            faz = 1 + azf;
            fbz = 1 + bzf;

            xfocus = x;
            yfocus = y;

            axf = ax*faz - x*azf;
            bxf = bx*fbz - x*bzf;
            ayf = ay*faz - y*azf;
            byf = by*fbz - y*bzf;

            det = dx*(axf - bxf) + dy*(ayf - byf);
            db = dx*(axf - x) + dy*(ayf - y);
            da = dx*(x - bxf) + dy*(y - byf);

            return (da*az + db*bz) / det;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function quarter(focus:Number):Array
        {
            if (length < 5)
                return null;

            var v01:ScreenVertex = ScreenVertex.median(v0, v1, focus);

            return [create(view, source, material, v0, v01), create(view, source, material, v01, v1)];
        }
		
		/**
		 * @inheritDoc
		 */
        public override function calc():void
        {
        	if (v0.z < v1.z) {
        		minZ = v0.z;
        		maxZ = v1.z + 1;
        	} else {
        		minZ = v1.z;
        		maxZ = v0.z + 1;
        	}
            screenZ = (v0.z + v1.z) / 2;
            
            if (v0.x < v1.x) {
        		minX = v0.x;
        		maxX = v1.x + 1;
        	} else {
        		minX = v1.x;
        		maxX = v0.x + 1;
        	}
        	
        	if (v0.y < v1.y) {
        		minY = v0.y;
        		maxY = v1.y + 1;
        	} else {
        		minY = v1.y;
        		maxY = v0.y + 1;
        	}
            
            length = Math.sqrt((maxX - minX)*(maxX - minX) + (maxY - minY)*(maxY - minY));
        }
        
		/**
		 * @inheritDoc
		 */
        public override function toString():String
        {
            return "S{ screenZ = " + screenZ + ", minZ = " + minZ + ", maxZ = " + maxZ + " }";
        }
    }
}
