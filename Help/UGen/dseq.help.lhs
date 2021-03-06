> import Sound.SC3 {- hsc3 -}

At control rate.

> g_01 =
>     let n = dseq 'α' 3 (mce [1,3,2,7,8])
>         x = mouseX KR 1 40 Exponential 0.1
>         t = impulse KR x 0
>         f = demand t 0 n * 30 + 340
>     in sinOsc AR f 0 * 0.1

At audio rate.

> g_02 =
>     let n = dseq 'α' dinf (mce [1,3,2,7,8,32,16,18,12,24])
>         x = mouseX KR 1 10000 Exponential 0.1
>         t = impulse AR x 0
>         f = demand t 0 n * 30 + 340
>     in sinOsc AR f 0 * 0.1

The SC2 Sequencer UGen is somewhat like the sequ function below

> g_03 =
>     let sequ e s tr = demand tr 0 (dseq e dinf (mce s))
>         t = impulse AR 6 0
>         n0 = sequ 'α' [60,62,63,58,48,55] t
>         n1 = sequ 'β' [63,60,48,62,55,58] t
>     in lfSaw AR (midiCPS (mce2 n0 n1)) 0 * 0.1

Rather than MCE expansion at _tr_, it can be clearer to view _tr_ as a
functor.

> gr_04 =
>     let tr = impulse KR (mce [2,3,5]) 0
>         f (z,t) = demand t 0 (dseq z dinf (mce [60,63,67,69]))
>         m = mce_map_ix f tr
>         o = sinOsc AR (midiCPS m) 0 * 0.1
>     in splay o 1 1 0 True
