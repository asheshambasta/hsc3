> Sound.SC3.UGen.Help.viewSC3Help "Crackle"
> Sound.SC3.UGen.DB.ugenSummary "Crackle"

> import Sound.SC3

> audition (out 0 (crackle AR 1.95 * 0.2))

Modulate chaos parameter

> audition (out 0 (crackle AR (line KR 1.0 2.0 3 RemoveSynth) * 0.2))


Drawing

> import Sound.SC3.Plot {- hsc3-plot -}

> plot_ugen1 0.01 (crackle AR 1.95)
> plot_ugen1 0.025 (crackle AR (line KR 1.0 2.0 0.025 DoNothing))