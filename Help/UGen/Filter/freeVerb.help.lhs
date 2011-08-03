freeVerb in mix room damp
freeVerb2 in1 in2 mix room damp

A simple reverb.

 in, in1, in2 - input signal
          mix - dry/wet balance (0,1)
         room - room size (0,1)
         damp - reverb high frequency damping (0,1)

> import Sound.SC3

> let { i = impulse AR 1 0
>     ; c = lfCub AR 1200 0
>     ; s = decay i 0.25 * c * 0.1
>     ; x = mouseX' KR 0 1 Linear 0.1
>     ; y = mouseY' KR 0 1 Linear 0.1
>     ; r = freeVerb s y x 0.5 }
> in audition (out 0 r)

> let { i = soundIn (mce2 0 1)
>     ; c = mceChannel
>     ; x = mouseX' KR 0 1 Linear 0.1
>     ; y = mouseY' KR 0 1 Linear 0.1
>     ; r = freeVerb2 (c 0 i) (c 1 i) y x 0.5 }
> in audition (out 0 r)
