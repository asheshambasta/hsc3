> Sound.SC3.UGen.Help.viewSC3Help "LFGauss"
> Sound.SC3.UGen.DB.ugenSummary "LFGauss"

> import Sound.SC3

modulating duration
> let {d = xLine KR 0.1 0.001 10 DoNothing
>     ;g = lfGauss AR d 0.03 0 Loop DoNothing}
> in audition (out 0 (g * 0.2))

modulating width, freq 60 Hz
> let {w = xLine KR 0.1 0.001 10 DoNothing
>     ;g = lfGauss AR (1/60) w 0 Loop DoNothing}
> in audition (out 0 (g * 0.2))

modulating both: x position is frequency, y is width factor.
note the artefacts due to alisasing at high frequencies
> let {d = mouseX KR (1/8000) 0.1 Exponential 0.2
>     ;w = mouseX KR 0.001 0.1 Exponential 0.2
>     ;g = lfGauss AR d w 0 Loop DoNothing}
> in audition (out 0 (g * 0.1))

LFGauss as amplitude modulator
> let {d = mouseX KR 1 0.001 Exponential 0.2
>     ;g = lfGauss AR d 0.1 0 Loop DoNothing
>     ;o = sinOsc AR 1000 0}
> in audition (out 0 (g * o * 0.1))

modulate iphase
> let {ph = mouseX KR (-1) 1 Linear 0.2
>     ;g = lfGauss AR 0.001 0.2 (mce2 0 ph) Loop DoNothing}
> in audition (out 0 (mix g * 0.2))

for very small width we are "approaching" a dirac function
> let {w = sampleDur * mouseX KR 10 3000 Exponential 0.2
>     ;g = lfGauss AR 0.01 w 0 Loop DoNothing}
> in audition (out 0 (g * 0.2))

dur and width can be modulated at audio rate
> let {x = mouseX KR 2 1000 Exponential 0.2
>     ;d = range 0.0006 0.01 (sinOsc AR x 0 * mce2 1 1.1)
>     ;w = range 0.01 0.3 (sinOsc AR (0.5 * (mce2 1 1.1)) 0)
>     ;g = lfGauss AR d w 0 Loop DoNothing}
> in audition (out 0 (g * 0.2))

several frequecies and widths combined
> let {x = mouseX KR 1 0.07 Exponential 0.2
>     ;y = mouseY KR 1 3 Linear 0.2
>     ;g = lfGauss AR x (y ** mce [-1,-2 .. -6]) 0 Loop DoNothing
>     ;o = sinOsc AR (200 * (1.3 ** mce [0..5])) 0}
> in audition (out 0 (mix (g * o) * 0.1))

> withSC3 (\fd -> send fd (n_trace [-1]))

gabor grain
> let {b = control IR "out" 0
>     ;f = control IR "freq" 440
>     ;s = control IR "sustain" 1
>     ;p = control IR "pan" 1
>     ;a = control IR "amp" 0.1
>     ;w = control IR "width" 0.25
>     ;e = lfGauss AR s w 0 NoLoop RemoveSynth
>     ;o = fSinOsc AR f (pi / 2) * e
>     ;u = offsetOut b (pan2 o p a)
>     ;i = synthdef "gabor" u}
> in withSC3 (\fd -> async fd (d_recv i))

> import Sound.SC3.Lang.Pattern.ID

granular synthesis, modulating duration, width and pan
> let {p = pbind [("freq",1000)
>                ,("legato",2)
>                ,("dur",pbrown 'a' 0.005 0.025 0.001 inf)
>                ,("width",pbrown 'b' 0.05 0.25 0.005 inf)
>                ,("pan",pbrown 'c' (-1) 1 0.05 inf)]}
> in audition ("gabor",p)