package away3d.materials
{
    import away3d.containers.*;
    import away3d.core.*;
    import away3d.core.base.*;
    import away3d.core.draw.*;
    import away3d.core.light.*;
    import away3d.core.math.*;
    import away3d.core.render.*;
    import away3d.core.utils.*;
    import away3d.events.*;
    
    import flash.display.*;
    import flash.events.*;

    /**
    * Abstract class for materials that calculate lighting for the face's center
    * Not intended for direct use - use <code>ShadingColorMaterial</code> or <code>WhiteShadingBitmapMaterial</code>.
    */
    public class CenterLightingMaterial extends EventDispatcher implements ITriangleMaterial
    {
    	use namespace arcane;
        /** @private */
        arcane var v0:ScreenVertex;
        /** @private */
        arcane var v1:ScreenVertex;
        /** @private */
        arcane var v2:ScreenVertex;
        /** @private */
        arcane var session:AbstractRenderSession;
		
		private var point:PointLight;
		private var directional:DirectionalLight;
		private var global:AmbientLight;
        private var focus:Number;
        private var zoom:Number;
        private var v0z:Number;
        private var v0p:Number;
        private var v0x:Number;
        private var v0y:Number;
        private var v1z:Number;
        private var v1p:Number;
        private var v1x:Number;
        private var v1y:Number;
        private var v2z:Number;
        private var v2p:Number;
        private var v2x:Number;
        private var v2y:Number;
        private var d1x:Number;
        private var d1y:Number;
        private var d1z:Number;
        private var d2x:Number;
        private var d2y:Number;
        private var d2z:Number;
        private var pa:Number;
        private var pb:Number;
        private var pc:Number;
        private var pdd:Number;
        private var c0x:Number;
        private var c0y:Number;
        private var c0z:Number;
        private var kar:Number;
        private var kag:Number;
        private var kab:Number;
        private var kdr:Number;
        private var kdg:Number;
        private var kdb:Number;
        private var ksr:Number;
        private var ksg:Number;
        private var ksb:Number;
        private var red:Number;
        private var green:Number;
        private var blue:Number;
        private var dfx:Number;
        private var dfy:Number;
        private var dfz:Number;
        private var df:Number;
        private var nx:Number;
        private var ny:Number;
        private var nz:Number;
        private var fade:Number;
        private var amb:Number;
        private var nf:Number;
        private var diff:Number;
        private var rfx:Number;
        private var rfy:Number;
        private var rfz:Number;
        private var spec:Number;
        private var rf:Number;
        private var graphics:Graphics;
        private var cz:Number;
        private var cx:Number;
        private var cy:Number;
        private var ncz:Number;
        private var ncx:Number;
        private var ncy:Number;
        private var sum:Number;
        private var ffz:Number;
        private var ffx:Number;
        private var ffy:Number;
        private var fz:Number;
        private var fx:Number;
        private var fy:Number;
        private var rz:Number;
        private var rx:Number;
        private var ry:Number;
        private var draw_normal:Boolean = false;
        private var draw_fall:Boolean = false;
        private var draw_fall_k:Number = 1;
        private var draw_reflect:Boolean = false;
        private var draw_reflect_k:Number = 1;
        private var _diffuseTransform:Matrix3D;
        private var _source:Mesh;
        
        /**
        * Instance of the Init object used to hold and parse default property values
        * specified by the initialiser object in the 3d object constructor.
        */
		protected var ini:Init;
		
        /** @private */
        protected function renderTri(tri:DrawTriangle, session:AbstractRenderSession, kar:Number, kag:Number, kab:Number, kdr:Number, kdg:Number, kdb:Number, ksr:Number, ksg:Number, ksb:Number):void
        {
            throw new Error("Not implemented");
        }
        
        /**
        * Coefficient for ambient light level
        */
        public var ambient_brightness:Number = 1;
        
        /**
        * Coefficient for diffuse light level
        */
        public var diffuse_brightness:Number = 1;
        
        /**
        * Coefficient for specular light level
        */
        public var specular_brightness:Number = 1;
        
        /**
        * Coefficient for shininess level
        */
        public var shininess:Number = 20;
		
		/**
		 * @private
		 */
        public function CenterLightingMaterial(init:Object = null)
        {
            ini = Init.parse(init);

            shininess = ini.getColor("shininess", 20);
        }
        
		/**
		 * @inheritDoc
		 */
        public function updateMaterial(source:Object3D, view:View3D):void
        {
        	for each (directional in source.lightarray.directionals) {
        		if (!directional.diffuseTransform[source] || view.scene.updatedObjects[source]) {
        			directional.setDiffuseTransform(source);
        		}
        	}
        }
        
		/**
		 * @inheritDoc
		 */
        public function renderTriangle(tri:DrawTriangle):void
        {
        	session = tri.source.session;
            v0 = tri.v0;
            v1 = tri.v1;
            v2 = tri.v2;
            focus = tri.view.camera.focus;
            zoom = tri.view.camera.zoom;

            v0z = v0.z;
            v0p = (1 + v0z / focus) / zoom;
            v0x = v0.x * v0p;
            v0y = v0.y * v0p;

            v1z = v1.z;
            v1p = (1 + v1z / focus) / zoom;
            v1x = v1.x * v1p;
            v1y = v1.y * v1p;

            v2z = v2.z;
            v2p = (1 + v2z / focus) / zoom;
            v2x = v2.x * v2p;
            v2y = v2.y * v2p;
            
            d1x = v1x - v0x;
            d1y = v1y - v0y;
            d1z = v1z - v0z;

            d2x = v2x - v0x;
            d2y = v2y - v0y;
            d2z = v2z - v0z;

            pa = d1y*d2z - d1z*d2y;
            pb = d1z*d2x - d1x*d2z;
            pc = d1x*d2y - d1y*d2x;
            pdd = Math.sqrt(pa*pa + pb*pb + pc*pc);
            
            pa /= pdd;
            pb /= pdd;
            pc /= pdd;

            c0x = (v0x + v1x + v2x) / 3;
            c0y = (v0y + v1y + v2y) / 3;
            c0z = (v0z + v1z + v2z) / 3;

            kar = kag = kab = kdr = kdg = kdb = ksr = ksg = ksb = 0;
			
			_source = tri.source as Mesh;
			
			for each (directional in tri.source.lightarray.directionals)
            {
            	_diffuseTransform = directional.diffuseTransform[_source];
            	
                red = directional.red;
                green = directional.green;
                blue = directional.blue;
				
                dfx = _diffuseTransform.szx;
				dfy = _diffuseTransform.szy;
				dfz = _diffuseTransform.szz;
                
                nx = tri.face.normal.x;
                ny = tri.face.normal.y;
                nz = tri.face.normal.z;
                
                amb = directional.ambient * ambient_brightness;
				
                kar += red * amb;
                kag += green * amb;
                kab += blue * amb;
                
                nf = dfx*nx + dfy*ny + dfz*nz;
				
                if (nf < 0)
                    continue;
				
                diff = directional.diffuse * nf * diffuse_brightness;
                
                kdr += red * diff;
                kdg += green * diff;
                kdb += blue * diff;
                
                rfx = _diffuseTransform.szx;
				rfy = _diffuseTransform.szy;
				rfz = _diffuseTransform.szz;
				
				rf = rfx*nx + rfy*ny + rfz*nz;
				
                spec = directional.specular * Math.pow(rf, shininess) * specular_brightness;
                
                ksr += red * spec;
                ksg += green * spec;
                ksb += blue * spec;
            }
            
            for each (point in tri.source.lightarray.points)
            {
                red = point.red;
                green = point.green;
                blue = point.blue;

                dfx = point.x - c0x;
                dfy = point.y - c0y;
                dfz = point.z - c0z;
                df = Math.sqrt(dfx*dfx + dfy*dfy + dfz*dfz);
                dfx /= df;
                dfy /= df;
                dfz /= df;
                fade = 1 / df / df;
                
                amb = point.ambient * fade * ambient_brightness;

                kar += red * amb;
                kag += green * amb;
                kab += blue * amb;
                
                nf = dfx*pa + dfy*pb + dfz*pc;

                if (nf < 0)
                    continue;

                diff = point.diffuse * fade * nf * diffuse_brightness;

                kdr += red * diff;
                kdg += green * diff;
                kdb += blue * diff;
                
                rfz = dfz - 2*nf*pc;

                if (rfz < 0)
                    continue;

                rfx = dfx - 2*nf*pa;
                rfy = dfy - 2*nf*pb;
                
                spec = point.specular * fade * Math.pow(rfz, shininess) * specular_brightness;

                ksr += red * spec;
                ksg += green * spec;
                ksb += blue * spec;
            }
			
            renderTri(tri, session, kar, kag, kab, kdr, kdg, kdb, ksr, ksg, ksb);
			
            if (draw_fall || draw_reflect || draw_normal)
            {
                graphics = session.graphics,
                cz = c0z,
                cx = c0x * zoom / (1 + cz / focus),
                cy = c0y * zoom / (1 + cz / focus);
                
                if (draw_normal)
                {
                    ncz = (c0z + 30*pc),
                    ncx = (c0x + 30*pa) * zoom * focus / (focus + ncz),
                    ncy = (c0y + 30*pb) * zoom * focus / (focus + ncz);

                    graphics.lineStyle(1, 0x000000, 1);
                    graphics.moveTo(cx, cy);
                    graphics.lineTo(ncx, ncy);
                    graphics.moveTo(cx, cy);
                    graphics.drawCircle(cx, cy, 2);
                }

                if (draw_fall || draw_reflect)
                    for each (point in tri.source.lightarray.points)
                    {
                        red = point.red;
                        green = point.green;
                        blue = point.blue;
                        sum = (red + green + blue) / 0xFF;
                        red /= sum;
                        green /= sum;
                        blue /= sum;
                
                        dfx = point.x - c0x;
                        dfy = point.y - c0y;
                        dfz = point.z - c0z;
                        df = Math.sqrt(dfx*dfx + dfy*dfy + dfz*dfz);
                        dfx /= df;
                        dfy /= df;
                        dfz /= df;
                
                        nf = dfx*pa + dfy*pb + dfz*pc;
                        if (nf < 0)
                            continue;
                
                        if (draw_fall)
                        {
                            ffz = (c0z + 30*dfz*(1-draw_fall_k)),
                            ffx = (c0x + 30*dfx*(1-draw_fall_k)) * zoom * focus / (focus + ffz),
                            ffy = (c0y + 30*dfy*(1-draw_fall_k)) * zoom * focus / (focus + ffz),

                            fz = (c0z + 30*dfz),
                            fx = (c0x + 30*dfx) * zoom * focus / (focus + fz),
                            fy = (c0y + 30*dfy) * zoom * focus / (focus + fz);

                            graphics.lineStyle(1, int(red)*0x10000 + int(green)*0x100 + int(blue), 1);
                            graphics.moveTo(ffx, ffy);
                            graphics.lineTo(fx, fy);
                            graphics.moveTo(ffx, ffy);
                        }

                        if (draw_reflect)
                        {
                            rfx = dfx - 2*nf*pa;
                            rfy = dfy - 2*nf*pb;
                            rfz = dfz - 2*nf*pc;
                    
                            rz = (c0z - 30*rfz*draw_reflect_k),
                            rx = (c0x - 30*rfx*draw_reflect_k) * zoom * focus / (focus + rz),
                            ry = (c0y - 30*rfy*draw_reflect_k) * zoom * focus / (focus + rz);
                        
                            graphics.lineStyle(1, int(red*0.5)*0x10000 + int(green*0.5)*0x100 + int(blue*0.5), 1);
                            graphics.moveTo(cx, cy);
                            graphics.lineTo(rx, ry);
                            graphics.moveTo(cx, cy);
                        }
                    }
            }
        }
        
		/**
		 * @private
		 */
        public function get visible():Boolean
        {
            throw new Error("Not implemented");
        }
        
		/**
		 * @inheritDoc
		 */
        public function addOnMaterialUpdate(listener:Function):void
        {
        	addEventListener(MaterialEvent.MATERIAL_UPDATED, listener, false, 0, true);
        }
        
		/**
		 * @inheritDoc
		 */
        public function removeOnMaterialUpdate(listener:Function):void
        {
        	removeEventListener(MaterialEvent.MATERIAL_UPDATED, listener, false);
        }
    }
}
