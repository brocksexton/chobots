/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package org.rje.glaze.engine.dynamics.joints {

	import flash.display.Graphics;	
	
	import org.rje.glaze.engine.math.*;
	import org.rje.glaze.engine.dynamics.*;

	public class GrooveJoint extends Joint {

Vector2D anchor1, anchor2;
Vector2D grv_a, grv_b, grv_n, grv_tn;
Vector2D r1, r2;
Vector2D k1, k2;
Vector2D jAcc, jBias;
Vector2D bias;
Number   clamp;

public function GrooveJoint(RigidBody a, RigidBody b, Vector2D groove_a, Vector2D groove_b, Vector2D anchor2)
{
    super(a, b);

    grv_a        = groove_a;
    grv_b        = groove_b;
    grv_n        = (groove_b - groove_a).normalize.perp;
    this.anchor2 = anchor2;
}

void preStep(Number dt_inv)
{
    // calculate endpoints in worldspace
    //Vector2D ta = cpBodyLocal2World(a, grv_a);
    //Vector2D tb = cpBodyLocal2World(a, grv_b);

    Vector2D ta = a.p - grv_a;
    Vector2D tb = a.p - grv_b;

    // calculate axis
    Vector2D n = grv_n.rotate(a.rot);
    Number   d = ta.dot(n);

    grv_tn = n;
    r2     = anchor2.rotate(b.rot);

    // calculate tangential distance along the axis of r2
    Number td = (b.p + r2).cross(n);
    // calculate clamping factor and r2
    if (td < ta.cross(n))
    {
        clamp = 1.0f;
        r1    = ta - a.p;
    }
    else if (td > tb.cross(n))
    {
        clamp = -1.0f;
        r1    = tb - a.p;
    }
    else
    {
        clamp = 0.0f;
        r1    = (n.perp * -td) + (n * d);
    }

    // calculate mass matrix
    Number k11, k12, k21, k22;
    Number m_sum = a.m_inv + b.m_inv;

    // start with I*m_sum
    k11 = m_sum; k12 = 0.0f;
    k21 = 0.0f;  k22 = m_sum;

    // add the influence from r1
    Number r1xsq = r1.x * r1.x * a.i_inv;
    Number r1ysq = r1.y * r1.y * a.i_inv;
    Number r1nxy = -r1.x * r1.y * a.i_inv;
    k11 += r1ysq; k12 += r1nxy;
    k21 += r1nxy; k22 += r1xsq;

    // add the influnce from r2
    Number r2xsq = r2.x * r2.x * b.i_inv;
    Number r2ysq = r2.y * r2.y * b.i_inv;
    Number r2nxy = -r2.x * r2.y * b.i_inv;
    k11 += r2ysq; k12 += r2nxy;
    k21 += r2nxy; k22 += r2xsq;

    // invert
    Number det_inv = 1.0f / (k11 * k22 - k12 * k21);
    k1 = Vector2D(k22 * det_inv, -k12 * det_inv);
    k2 = Vector2D(-k21 * det_inv, k11 * det_inv);

    // calculate bias velocity
    Vector2D delta = (b.p + r2) - (a.p + r1);
    bias  = delta * (-JOINT_BIASCOEF * dt_inv);
    jBias = Vector2D.zeroVect;

    // apply accumulated impulse
    a.applyImpulse(-jAcc, r1);
    b.applyImpulse(jAcc, r2);
}

Vector2D grooveConstrain(Vector2D j)
{
    Vector2D n  = grv_tn;
    Vector2D jn = n * j.dot(n);

    Vector2D t    = n.perp;
    Number   coef = (clamp * j.cross(n) > 0.0f) ? 1.0f : 0.0f;
    Vector2D jt   = t * (j.dot(t) * coef);

    return jn + jt;
}

void applyImpulse()
{
    //calculate bias impulse
    Vector2D vb1 = a.v_bias + (r1.perp * a.w_bias);
    Vector2D vb2 = b.v_bias + (r2.perp * b.w_bias);
    Vector2D vbr = bias - (vb2 - vb1);

    Vector2D jb    = Vector2D(vbr.dot(k1), vbr.dot(k2));
    Vector2D jbOld = jBias;
    jBias = grooveConstrain(jbOld + jb);
    jb    = jBias - jbOld;

    a.applyBiasImpulse(-jb, r1);
    b.applyBiasImpulse(jb, r2);

    // compute relative velocity
    Vector2D v1 = (a.v + (r1.perp * a.w));
    Vector2D v2 = (b.v + (r2.perp * b.w));
    Vector2D vr = v2 - v1;

    // compute impulse
    Vector2D j    = Vector2D(-vr.dot(k1), -vr.dot(k2));
    Vector2D jOld = jAcc;
    jAcc = grooveConstrain(jOld + j);
    j    = jAcc - jOld;

    // apply impulse
    a.applyBiasImpulse(-j, r1);
    b.applyBiasImpulse(j, r2);
}
}
