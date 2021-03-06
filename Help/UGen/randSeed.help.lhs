> import Sound.SC3

start a noise patch

> g_01 =
>     let n = uclone 'α' 2 (whiteNoise 'β' AR * 0.05 + dust2 'γ' AR 70)
>         f = lfNoise1 'δ' KR 3 * 5500 + 6000
>     in resonz (n * 5) f 0.5 + n * 0.5

reset the seed at a variable rate (crash?)

> g_02 =
>      let s = 1956 -- control KR "seed" 1956
>          i = impulse KR (mouseX KR 0.1 100 Linear 0.2) 0
>      in randSeed KR i s

always the same (for a given seed)... (crash!)

> g_03 =
>     let sd = 1957
>         n = tiRand 'α' 4 12 (dust 'β' KR 1)
>         f = n * 150 + (mce [0,1])
>         r = randSeed IR 1 sd
>     in mrg2 (sinOsc AR f 0 * 0.1) r
