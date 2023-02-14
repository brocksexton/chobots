package away3d.core.math
{
    /**
    * A point in 3D space.
    */
    public final class Number3D
    {
    	private const toDEGREES:Number = 180 / Math.PI;
    	private var mod:Number;
        private var dist:Number;
        private var num:Number3D;
        private var vx:Number;
        private var vy:Number;
        private var vz:Number;
        private var nx:Number;
        private var ny:Number;
        private var nz:Number;
        private var m1:Matrix3D;
        private var m2:Matrix3D;
        
        /**
        * The horizontal coordinate of the 3d number object.
        */ 
        public var x:Number;
    
        /**
        * The vertical coordinate of the 3d number object.
        */ 
        public var y:Number;
    
        /**
        * The depth coordinate of the 3d number object.
        */ 
        public var z:Number;
    	
    	/**
    	 * The modulo of the 3d number object.
    	 */
        public function get modulo():Number
        {
            return Math.sqrt(x*x + y*y + z*z);
        }
    	
    	/**
    	 * The squared modulo of the 3d number object.
    	 */
        public function get modulo2():Number
        {
            return x*x + y*y + z*z;
        }
        
		/**
		 * Creates a new <code>Number3D</code> object.
		 *
		 * @param	x	[optional]	A default value for the horizontal coordinate of the 3d number object. Defaults to 0.
		 * @param	y	[optional]	A default value for the vertical coordinate of the 3d number object. Defaults to 0.
		 * @param	z	[optional]	A default value for the depth coordinate of the 3d number object. Defaults to 0.
		 * @param	n	[optional]	Determines of the resulting 3d number object should be normalised. Defaults to false.
		 */
        public function Number3D(x:Number = 0, y:Number = 0, z:Number = 0, n:Boolean = false)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            
            if (n)
            	normalize();
        }
		
		/**
		 * Duplicates the 3d number's properties to another <code>Number3D</code> object
		 * 
		 * @return	The new 3d number instance with duplicated properties applied
		 */
        public function clone(v:Number3D):void
        {
            x = v.x;
            y = v.y;
            z = v.z;
        }
		
    	/**
    	 * Fills the 3d number object with scaled values from the given 3d number.
    	 * 
    	 * @param	v	The 3d number object used for the scaling calculation.
    	 * @param	s	The scaling value.
    	 */
        public function scale(v:Number3D, s:Number):void
        {
            x = v.x * s;
            y = v.y * s;
            z = v.z * s;
        }  
		
    	/**
    	 * Fills the 3d number object with the result from an addition of two 3d numbers.
    	 * 
    	 * @param	v	The first 3d number in the addition.
    	 * @param	w	The second 3d number in the addition.
    	 */
        public function add(v:Number3D, w:Number3D):void
        {
            x = v.x + w.x;
            y = v.y + w.y;
            z = v.z + w.z;
        }
		
    	/**
    	 * Fills the 3d number object with the result from a subtraction of two 3d numbers.
    	 * 
    	 * @param	v	The starting 3d number in the subtraction.
    	 * @param	w	The subtracting 3d number in the subtraction.
    	 */
        public function sub(v:Number3D, w:Number3D):void
        {
            x = v.x - w.x;
            y = v.y - w.y;
            z = v.z - w.z;
        }
    	
    	/**
    	 * Calculates the distance from the 3d number object to the given 3d number.
    	 * 
    	 * @param	w	The 3d number object whose distance is calculated.
    	 */
        public function distance(w:Number3D):Number
        {
            return Math.sqrt((x - w.x)*(x - w.x) + (y - w.y)*(y - w.y) + (z - w.z)*(z - w.z));
        }
    	
    	/**
    	 * Calculates the dot product of the 3d number object with the given 3d number.
    	 * 
    	 * @param	w	The 3d number object to use in the calculation.
    	 * @return		The dot product result.
    	 */
        public function dot(w:Number3D):Number
        {
            return (x * w.x + y * w.y + z * w.z);
        }
		
    	/**
    	 * Fills the 3d number object with the result from an cross product of two 3d numbers.
    	 * 
    	 * @param	v	The first 3d number in the cross product calculation.
    	 * @param	w	The second 3d number in the cross product calculation.
    	 */
        public function cross(v:Number3D, w:Number3D):void
        {
        	if (this == v || this == w)
        		throw new Error("resultant cross product cannot be the same instance as an input");
        	x = w.y * v.z - w.z * v.y;
        	y = w.z * v.x - w.x * v.z;
        	z = w.x * v.y - w.y * v.x;
        }
    	
    	/**
    	 * Returns the angle in radians made between the 3d number obejct and the given 3d number.
    	 * 
    	 * @param	w	[optional]	The 3d number object to use in the calculation.
    	 * @return					An angle in radians representing the angle between the two 3d number objects. 
    	 */
        public function getAngle(w:Number3D = null):Number
        {
            if (w == null)
            	w = new Number3D();
            return Math.acos(dot(w)/(modulo*w.modulo));
        }
        
        /**
        * Normalises the 3d number object.
        * @param	val	[optional]	A normalisation coefficient representing the length of the resulting 3d number object. Defaults to 1.
        */
        public function normalize(val:Number = 1):void
        {
            mod = modulo/val;
    
            if (mod != 0 && mod != 1)
            {
                x /= mod;
                y /= mod;
                z /= mod;
            }
        }
    	
    	/**
    	 * Fills the 3d number object with the result of a 3d matrix rotation performed on a 3d number.
    	 * 
    	 * @param	v	The 3d number object to use in the calculation.
    	 * @param	m	The 3d matrix object representing the rotation.
    	 */
        public function rotate(v:Number3D, m:Matrix3D):void
        {
        	vx = v.x;
        	vy = v.y;
        	vz = v.z;
        	
            x = vx * m.sxx + vy * m.sxy + vz * m.sxz;
            y = vx * m.syx + vy * m.syy + vz * m.syz;
            z = vx * m.szx + vy * m.szy + vz * m.szz;
        }
    	
    	/**
    	 * Fills the 3d number object with the result of a 3d matrix tranformation performed on a 3d number.
    	 * 
    	 * @param	v	The 3d number object to use in the calculation.
    	 * @param	m	The 3d matrix object representing the tranformation.
    	 */
        public function transform(v:Number3D, m:Matrix3D):void
        {
        	vx = v.x;
        	vy = v.y;
        	vz = v.z;
        	
            x = vx * m.sxx + vy * m.sxy + vz * m.sxz + m.tx;
            y = vx * m.syx + vy * m.syy + vz * m.syz + m.ty;
            z = vx * m.szx + vy * m.szy + vz * m.szz + m.tz;
        }
            	
    	/**
    	 * Fill the 3d number object with the euler angles represented by the 3x3 matrix rotation.
    	 * 
    	 * @param	m	The 3d matrix object to use in the calculation.
    	 */
        public function matrix2euler(m:Matrix3D, scaleX:Number = 1, scaleY:Number = 1, scaleZ:Number = 1):void
        {
    		/*
            var d :Number = -Math.asin(Math.max(-1, Math.min(1,m.sxz))); // Calculate Y-axis angle
            var c :Number =  Math.cos(d);
    
            y = d;
    
            var trX:Number, trY:Number;
    
            if (Math.abs(c) > 0.005)  // Gimball lock?
            {
                trX =  m.szz / c;  // No, so get X-axis angle
                trY = -m.syz / c;
    
                x = Math.atan2(trY, trX);
    
                trX =  m.sxx / c;  // Get Z-axis angle
                trY = -m.sxy / c;
    
                z = Math.atan2(trY, trX);
            }
            else  // Gimball lock has occurred
            {
                x = 0;  // Set X-axis angle to zero
    
                trX = m.syy;  // And calculate Z-axis angle
                trY = m.syx;
    
                z = Math.atan2(trY, trX);
            }
            */
            if (!m1)
            	m1 = new Matrix3D();
            	
            if (!m2)
            	m2 = new Matrix3D();
            	
            if (scaleX)
            	scaleX = 1/scaleX;
            
            if (scaleY)
            	scaleY = 1/scaleY;
            	
            if (scaleZ)
            	scaleZ = 1/scaleZ;
            
            // Normalize the local x, y and z axes to remove scaling.
            if (scaleX != 1 || scaleY != 1 || scaleZ != 1)
            	m1.scale(m, scaleX, scaleY, scaleZ);
            else
            	m1.clone(m);
	
		    // Extract the first angle, rotationX
			x = Math.atan2(m1.syz, m1.szz); // rot.x = Math<T>::atan2 (M[1][2], M[2][2]);
			
			// Remove the rotationX rotation from m1, so that the remaining
			// rotation, m2 is only around two axes, and gimbal lock cannot occur.
			
			var c :Number   = Math.cos(-x);
			var s :Number   = Math.sin(-x);
			m2.sxx = m1.sxx;
			m2.sxy = m1.sxy*c + m1.sxz*s;
			m2.sxz = -m1.sxy*s + m1.sxz*c;
			m2.syx = m1.syx;
			m2.syy = m1.syy*c + m1.syz*s;
			m2.syz = -m1.syy*s + m1.syz*c;
			m2.szx = m1.szx;
			m2.szy = m1.szy*c + m1.szz*s;
			m2.szz = -m1.szy*s + m1.szz*c;
			//m2.rotationMatrix(1, 0, 0, -x);
			//m2.multiply3x3(m2, m1);
			// Extract the other two angles, rot.y and rot.z, from m2.
			var cy:Number = Math.sqrt(m2.sxx*m2.sxx + m2.syx*m2.syx); // T cy = Math<T>::sqrt (N[0][0]*N[0][0] + N[0][1]*N[0][1]);
			y = Math.atan2(-m2.szx, cy); // rot.y = Math<T>::atan2 (-N[0][2], cy);
			z = Math.atan2(-m2.sxy, m2.syy); //rot.z = Math<T>::atan2 (-N[1][0], N[1][1]);
	
			// Fix angles
			if(x == Math.PI) {
				if(y > 0)
					y -= Math.PI;
				else
					y += Math.PI;
	
				x = 0;
				z += Math.PI;
			}
        }
        
        public function quaternion2euler(quarternion:Quaternion):void
		{
			
			var test :Number = quarternion.x*quarternion.y + quarternion.z*quarternion.w;
			if (test > 0.499) { // singularity at north pole
				x = 2 * Math.atan2(quarternion.x,quarternion.w);
				y = Math.PI/2;
				z = 0;
				return;
			}
			if (test < -0.499) { // singularity at south pole
				x = -2 * Math.atan2(quarternion.x,quarternion.w);
				y = - Math.PI/2;
				z = 0;
				return;
			}
		    
		    var sqx	:Number = quarternion.x*quarternion.x;
		    var sqy	:Number = quarternion.y*quarternion.y;
		    var sqz	:Number = quarternion.z*quarternion.z;
		    
		    x = Math.atan2(2*quarternion.y*quarternion.w - 2*quarternion.x*quarternion.z , 1 - 2*sqy - 2*sqz);
			y = Math.asin(2*test);
			z = Math.atan2(2*quarternion.x*quarternion.w-2*quarternion.y*quarternion.z , 1 - 2*sqx - 2*sqz);
		}
		
    	/**
    	 * Fill the 3d number object with the scale values represented by the 3x3 matrix.
    	 * 
    	 * @param	m	The 3d matrix object to use in the calculation.
    	 */
        public function matrix2scale(m:Matrix3D):void
        {
            x = Math.sqrt(m.sxx*m.sxx + m.syx*m.syx + m.szx*m.szx);
            y = Math.sqrt(m.sxy*m.sxy + m.syy*m.syy + m.szy*m.szy);
            z = Math.sqrt(m.sxz*m.sxz + m.syz*m.syz + m.szz*m.szz);
        }
        
        /**
        * A 3d number object representing a relative direction forward.
        */
        public static var FORWARD :Number3D = new Number3D( 0,  0,  1);
        
        /**
        * A 3d number object representing a relative direction backward.
        */
        public static var BACKWARD:Number3D = new Number3D( 0,  0, -1);
        
        /**
        * A 3d number object representing a relative direction left.
        */
        public static var LEFT    :Number3D = new Number3D(-1,  0,  0);
        
        /**
        * A 3d number object representing a relative direction right.
        */
        public static var RIGHT   :Number3D = new Number3D( 1,  0,  0);
        
        /**
        * A 3d number object representing a relative direction up.
        */
        public static var UP      :Number3D = new Number3D( 0,  1,  0);
        
        /**
        * A 3d number object representing a relative direction down.
        */
        public static var DOWN    :Number3D = new Number3D( 0, -1,  0);
        
        /**
        * Calculates a 3d number object representing the closest point on a given plane to a given 3d point.
        * 
        * @param	p	The 3d point used in teh calculation.
        * @param	k	The plane offset used in the calculation.
        * @param	n	The plane normal used in the calculation.
        * @return		The resulting 3d point.
        */
        public function closestPointOnPlane(p:Number3D, k:Number3D, n:Number3D):Number3D
        {
        	if (!num)
        		num = new Number3D();
        	
        	num.sub(p, k);
            dist = n.dot(num);
            num.scale(n, dist);
            num.sub(p, num);
            return num;
        }
		
		/**
		 * Used to trace the values of a 3d number.
		 * 
		 * @return A string representation of the 3d number object.
		 */
        public function toString(): String
        {
            return 'x:' + x + ' y:' + y + ' z:' + z;
        }
    }
}