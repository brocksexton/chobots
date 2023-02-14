/*******************************************************************************

        Authors: Blaze team, see AUTHORS file
        Maintainers: Mason Green (zzzzrrr)
        License:
                zlib/png license

                This software is provided 'as-is', without any express or implied
                warranty. In no event will the authors be held liable for any damages
                arising from the use of this software.

                Permission is granted to anyone to use this software for any purpose,
                including commercial applications, and to alter it and redistribute it
                freely, subject to the following restrictions:

                        1. The origin of this software must not be misrepresented; you must not
                        claim that you wrote the original software. If you use this software
                        in a product, an acknowledgment in the product documentation would be
                        appreciated but is not required.

                        2. Altered source versions must be plainly marked as such, and must not be
                        misrepresented as being the original software.

                        3. This notice may not be removed or altered from any source
                        distribution.

        Copyright: 2008, Blaze Team

*******************************************************************************/
module blaze.dynamics.joints.SlideJoint;

import tango.math.Math;

import blaze.common.Common;
import blaze.common.Vector2D;
import blaze.dynamics.RigidBody;
import blaze.dynamics.joints.Joint;

// A joint for connecting two bodies with given anchor points as well
/// as a minimum and maximum distance allowed between the anchor points.
public class SlideJoint : Joint
{
Vector2D anchor1, anchor2;
Number   min, max;

Vector2D r1, r2;
Vector2D n;
Number   nMass;

Number   jnAcc, jBias;
Number   bias;

/// Creates a slide joint connecting two bodies
this(RigidBody a, RigidBody b, Vector2D anchor1, Vector2D anchor2, Number min, Number max)
{
    super(a, b);
    this.anchor1 = anchor1;
    this.anchor2 = anchor2;

    this.min = min;
    this.max = max;
}

/// Prepares the joint by calculating impulses
override void preStep(Number dt_inv)
{
    Number mass_sum = a.m_inv + b.m_inv;

    r1 = anchor1.rotate(a.rot);
    r2 = anchor2.rotate(b.rot);

    Vector2D delta = (b.p + r2) - (a.p + r1);
    Number   dist  = delta.magnitude();
    Number   pdist = 0f;
    if (dist > max)
    {
        pdist = dist - max;
    }
    else if (dist < min)
    {
        pdist = min - dist;
        pdist = -pdist;
    }
    n = delta * (1f / ((dist != 0f) ? dist : POSITIVE_INFINITY));

    // calculate mass normal
    Number r1cn = r1.cross(n);
    Number r2cn = r2.cross(n);
    Number kn   = mass_sum + (a.i_inv * r1cn * r1cn) + (b.i_inv * r2cn * r2cn);
    nMass = 1f / kn;

    // calculate bias velocity
    bias  = -JOINT_BIASCOEF * dt_inv * pdist;
    jBias = 0f;

    // apply accumulated impulse
    if (bias == 0f)
        jnAcc = 0f;
    Vector2D j = n * jnAcc;
    a.applyImpulse(-j, r1);
    b.applyImpulse(j, r2);
}

/// Applies any impulses to the two bodies
override void applyImpulse()
{
    if (bias == 0f)
        return;

    //calculate bias impulse
    Vector2D vb1 = a.v_bias + (r1.perp * a.w_bias);
    Vector2D vb2 = b.v_bias + (r2.perp * b.w_bias);
    Number   vbn = (vb2 - vb1).dot(n);

    Number   jbn    = (bias - vbn) * nMass;
    Number   jbnOld = jBias;
    jBias = minNum(jbnOld + jbn, 0f);
    jbn   = jBias - jbnOld;

    Vector2D jb = n * jbn;
    a.applyBiasImpulse(-jb, r1);
    b.applyBiasImpulse(jb, r2);

    // compute relative velocity
    Vector2D v1  = a.v + (r1.perp * a.w);
    Vector2D v2  = b.v + (r2.perp * b.w);
    Number   vrn = (v2 - v1).dot(n);

    // compute normal impulse
    Number jn    = -vrn * nMass;
    Number jnOld = jnAcc;
    jnAcc = minNum(jnOld + jn, 0f);
    jn    = jnAcc - jnOld;

    // apply impulse
    Vector2D j = n * jn;
    a.applyImpulse(-j, r1);
    b.applyImpulse(j, r2);
}
}
