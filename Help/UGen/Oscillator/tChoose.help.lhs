tChoose trig inputs

The output is selected randomly on recieving a trigger from an
array of inputs.  tChoose is a composite of tiRand and select.

> let x = mouseX kr 1 1000 Exponential 0.1
> in do { t <- dust ar x
>       ; f <- liftM midiCPS (tiRand 48 60 t)
>       ; o <- let a = mce [ sinOsc ar f 0
>                          , saw ar (f * 2)
>                          , pulse ar (f * 0.5) 0.1 ]
>              in tChoose t a
>       ; audition (out 0 (o * 0.1)) }

;; Note: all the ugens are continously running. This may not be the
;; most efficient way if each input is cpu-expensive.
