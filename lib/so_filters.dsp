import("stdfaust.lib");
import("stdfaust.lib");

// =============================================================================
// Auxiliary functions =========================================================
// =============================================================================

// -----------------------------------------------------------------------------
// Floating-point limit constants and clipping function.
//
MAX = ma.INFINITY;
MIN = ma.MIN;
E = ma.EPSILON;
clip(l, h, x) = max(l, min(h, x));
// -----------------------------------------------------------------------------

// =============================================================================

MAX_clip = 1024 ^ hslider("clip_bounds", 0, 0, 1, .000001);

int_clip(l, h, x) = clip(l, h, +(x)) ~ _;

ddsm1_clip(G, x) = y
    letrec {
        'y = ba.if(int_clip(-MAX_clip, MAX_clip, x - G * y) < 0, -1, 1);
    };
ddsm2_clip(G, x) = loop
           ~ _
      with {
           loop(fb) = Q(int_clip(-MAX_clip, MAX_clip, int_clip(-MAX_clip, MAX_clip, (x - fb * G)) - 2 * fb * G));
           Q(z) = ba.if(z < 0, -1, 1);
      };

ddsm1(G, x) = y
    letrec {
        'y = ba.if(fi.pole(1, x - G * y) < 0, -1, 1);
    };
ddsm2(G, x) = loop
           ~ _
      with {
           loop(fb) = Q(fi.pole(1, fi.pole(1, (x - fb * G)) - 2 * fb * G));
           Q(z) = ba.if(z < 0, -1, 1);
      };

int1bit(G, x) = ddsm1(G, fi.pole(1, x));
int1bit2(G, x) = ddsm2(G, fi.pole(1, x));

int1bit_clip(G, x) = ddsm1_clip(G, int_clip(-MAX_clip, MAX_clip, x));
int1bit2_clip(G, x) = ddsm2_clip(G, int_clip(-MAX_clip, MAX_clip, x));

lp1bit(cf, x) = y
    letrec {
        'y = int1bit(1, (x - y) * cf);
    };
hp1bit(cf, x) = ddsm1(1, x - y)
    letrec {
        'y = int1bit(1, (x - y) * cf);
    };

lp1bit2(cf, x) = y
    letrec {
        'y = int1bit2(1, (x - y) * cf);
    };
hp1bit2(cf, x) = ddsm2(1, x - y)
    letrec {
        'y = int1bit2(1, (x - y) * cf);
    };

lp1bit_clip(cf, x) = y
    letrec {
        'y = int1bit_clip(1, (x - y) * cf);
    };
hp1bit_clip(cf, x) = ddsm1_clip(1, x - y)
    letrec {
        'y = int1bit_clip(1, (x - y) * cf);
    };

lp1bit2_clip(cf, x) = y
    letrec {
        'y = int1bit2_clip(1, (x - y) * cf);
    };
hp1bit2_clip(cf, x) = ddsm2_clip(1, x - y)
    letrec {
        'y = int1bit2_clip(1, (x - y) * cf);
    };



bit2mbit(x) = fi.lowpass(4, 4000, x);
G = hslider("FB gain", 1, 1, 4, 1);
//in = os.osc(1000);
in = no.noise;
cf1 = hslider("cf1", 0.1, 0, 1, .000001);
cf2 = hslider("cf2", 0.1, 0, 1, .000001);
fb = hslider("fb", 0.1, -1, 1, .000001);
del = hslider("del", 0, 0, 64, 1);
and(x, y) = ba.if((x > 0) & (y > 0), 1, -1);
or(x, y) = ba.if((x > 0) | (y > 0), 1, -1);
osc_test = y1 , y2
    letrec {
        'y1 = lp1bit2(cf1, y2 * fb);
        'y2 = hp1bit2(cf2, y1 * fb);
    };
osc_test2 = y1 , y2
    letrec {
        'y1 = lp1bit2(cf1, and(y1, y2) * fb);
        'y2 = lp1bit2(cf2, or(y1, y2) * fb);
    };

test_clip = y1 , y2
    letrec {
        'y1 = lp1bit_clip(cf1, y2 * fb);
        'y2 = hp1bit_clip(cf2, y1 * fb);
    };

test_clip2 = y1 , y2
    letrec {
        'y1 = lp1bit2_clip(cf1, y2 * fb);
        'y2 = lp1bit2_clip(cf2, y1 * fb);
    };

process = test_clip;
