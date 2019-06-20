> import Sound.SC3 {- hsc3 -}

Find indexes and map to an audible frequency range.

> g_01 =
>     let n = 6
>         x = floorE (mouseX KR 0 n Linear 0.1)
>         i = detectIndex (asLocalBuf 'α' [2,3,4,0,1,5]) x
>     in sinOsc AR (linExp i 0 n 200 700) 0 * 0.1
