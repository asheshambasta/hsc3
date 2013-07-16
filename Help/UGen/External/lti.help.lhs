> Sound.SC3.UGen.Help.viewSC3Help "LTI"
> Sound.SC3.UGen.DB.ugenSummary "LTI"

> import Sound.SC3.ID

> let {a = [0.02,-0.01]
>     ;b = [1,0.7,0,0,0,0,-0.8,0,0,0,0,0.9,0,0,0,-0.5,0,0,0,0,0,0,0.25,0.1,0.25]
>     ;z = pinkNoise 'a' AR * 0.1 {- soundIn 4 -}
>     ;f = lti AR z (asLocalBuf 'a' a) (asLocalBuf 'b' b)}
> in audition (out 0 f)