> Sound.SC3.UGen.Help.viewSC3Help "TRand"
> Sound.SC3.UGen.DB.ugenSummary "TRand"

> import Sound.SC3.ID

> let {t = dust 'a' KR (mce2 5 12)
>     ;f = tRand 'b' (mce2 200 1600) (mce2 500 3000) t}
> in audition (out 0 (sinOsc AR f 0 * 0.2))
