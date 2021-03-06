> import Sound.SC3 {- hsc3 -}

using PauseSynth done action

> g_01 =
>     let x = mouseX KR (-1) 1 Linear 0.1
>         e = linen x 1 0.1 1 PauseSynth
>     in sinOsc AR 440 0 * e

Run paused node (assuming no intermediate node is created).

    > withSC3 (Sound.OSC.sendMessage (n_run [(-1, True)]))

using pauseSelfWhenDone UGen

> g_02 =
>     let x = mouseX KR (-1) 1 Linear 0.1
>         e = linen x 1 0.1 1 DoNothing
>         o = sinOsc AR 440 0 * e
>     in mrg [o,pauseSelfWhenDone e]

    > withSC3 (Sound.OSC.sendMessage (n_run [(-1, True)]))
