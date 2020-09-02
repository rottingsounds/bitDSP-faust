import("stdfaust.lib");
integrator = fi.pole(1);
Q(x) = ba.if(x < 0, -1, 1);
process(x) = ((x - _ : integrator) - _ * 2 : integrator : Q) ~ (_ <: _ , _);
