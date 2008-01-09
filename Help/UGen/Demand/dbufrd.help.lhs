dbufrd bufnum phase loop

Buffer demand ugen.

bufnum  - buffer number to read from
phase   - index into the buffer (demand ugen or any other ugen)
loop    - loop when phase exceeds number of frames in buffer

Example

> let n = randomRs (200.0, 500.0) (mkStdGen 0)
> in do { withSC3 (\fd -> do { send fd (b_alloc 10 24 1)
>                            ; wait fd "/done"
>                            ; send fd (b_setn 10 [(0, take 24 n)]) })
>       ; s <- dseq 3 (mce [0, 3, 5, 0, 3, 7, 0, 5, 9])
>       ; b <- dbrown 5 0 23 1
>       ; p <- dseq 8192 (mce [s, b])
>       ; t <- dust KR 10
>       ; r <- dbufrd 10 p Loop
>       ; audition (out 0 (sinOsc AR (demand t 0 r) 0 * 0.1)) }

Buffer as a time pattern (requires buffer 10 as allocated above).

> let { i = randomRs (0, 2) (mkStdGen 0)
>     ; n = map ([1, 0.5, 0.25] !!) i }
> in do { withSC3 (\fd -> do { send fd (b_alloc 11 24 1)
>                            ; wait fd "/done"
>                            ; send fd (b_setn 11 [(0, take 24 n)]) })
>       ; s <- dseq 3 (mce [0, 3, 5, 0, 3, 7, 0, 5, 9])
>       ; b <- dbrown 5 0 23 1
>       ; p <- dseq 8192 (mce [s, b])
>       ; j <- dseries 8192 0 1
>       ; d <- dbufrd 11 j Loop
>       ; l <- dbufrd 10 p Loop
>       ; let f = duty KR (d * 0.5) 0 DoNothing l
>         in audition (out 0 (sinOsc AR f 0 * 0.1)) }

Free buffers

> withSC3 (\fd -> do { send fd (b_free 10)
>                    ; wait fd "/done"
>                    ; send fd (b_free 11)
>                    ; wait fd "/done" })
