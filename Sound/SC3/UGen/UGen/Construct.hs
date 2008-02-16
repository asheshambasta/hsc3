module Sound.SC3.UGen.UGen.Construct ( mkUnaryOperator, mkBinaryOperator
                                     , mkOscId, mkOsc
                                     , mkOscMCEId, mkOscMCE
                                     , mkFilterId, mkFilter, mkFilterKeyed
                                     , mkFilterMCE
                                     , liftU, liftU2, liftU3, liftU4 ) where

import Sound.SC3.UGen.Operator
import Sound.SC3.UGen.Rate
import Sound.SC3.UGen.UGen
import Sound.SC3.UGen.UGen.MCE
import Sound.SC3.UGen.UGen.Predicate
import Sound.SC3.UGen.UId

-- * UGen Constructors.

-- | Apply proxy transformation if required.
proxify :: UGen -> UGen
proxify u 
    | isMCE u = mce (map proxify (mceProxies u))
    | isMRG u = mrg [proxify (mrgLeft u), mrgRight u]
    | isUGen u = let o = ugenOutputs u
                 in case o of
                      (_:_:_) -> mce (map (proxy u) [0..(length o - 1)])
                      _ -> u
    | otherwise = error "proxify: illegal ugen"

-- | Determine the rate of a UGen.
rateOf :: UGen -> Rate
rateOf u
    | isConstant u = IR
    | isControl u = controlRate_ u
    | isUGen u = ugenRate u
    | isProxy u = rateOf (proxySource u)
    | isMCE u = maximum (map rateOf (mceProxies u))
    | isMRG u = rateOf (mrgLeft u)
    | otherwise = undefined

-- | True is input is a sink UGen, ie. has no outputs.
isSink :: UGen -> Bool
isSink u
    | isUGen u = null (ugenOutputs u)
    | isMCE u = all isSink (mceProxies u)
    | isMRG u = isSink (mrgLeft u)
    | otherwise = False

-- | Ensure input UGen is valid, ie. not a sink.
checkInput :: UGen -> UGen
checkInput u = if isSink u then error ("illegal input" ++ show u) else u

-- | Construct proxied and multiple channel expanded UGen.
mkUGen :: Rate -> Name -> [UGen] -> [Output] -> Special -> Maybe UGenId -> UGen
mkUGen r n i o s z = proxify (mceExpand u)
    where u = Primitive r n (map checkInput i) o s z

-- | Operator UGen constructor.
mkOperator :: Name -> [UGen] -> Int -> UGen
mkOperator c i s = mkUGen r c i [r] (Special s) Nothing
    where r = maximum (map rateOf i)

-- | Unary math constructor with constant optimization.
mkUnaryOperator :: Unary -> (Double -> Double) -> UGen -> UGen
mkUnaryOperator i f a 
    | isConstant a = constant (f (constantValue a))
    | otherwise = mkOperator "UnaryOpUGen" [a] (fromEnum i)

-- | Binary math constructor with constant optimization.
mkBinaryOperator :: Binary -> (Double -> Double -> Double) -> UGen -> UGen -> UGen
mkBinaryOperator i f a b 
    | isConstant a && isConstant b = let a' = constantValue a
                                         b' = constantValue b
                                     in constant (f a' b')
    | otherwise = mkOperator "BinaryOpUGen" [a, b] (fromEnum i)

mkOsc_ :: Maybe UGenId -> Rate -> Name -> [UGen] -> Int -> UGen
mkOsc_ z r c i o = mkUGen r c i (replicate o r) (Special 0) z

-- | Oscillator constructor.
mkOsc :: Rate -> Name -> [UGen] -> Int -> UGen
mkOsc = mkOsc_ Nothing

-- | Oscillator constructor, setting identifier.
mkOscId :: UGenId -> Rate -> Name -> [UGen] -> Int -> UGen
mkOscId z = mkOsc_ (Just z)

mkOscMCE_ :: Maybe UGenId -> Rate -> Name -> [UGen] -> UGen -> Int -> UGen
mkOscMCE_ z r c i j o = mkOsc_ z r c (i ++ mceChannels j) o

-- | Variant oscillator constructor with MCE collapsing input.
mkOscMCE :: Rate -> Name -> [UGen] -> UGen -> Int -> UGen
mkOscMCE = mkOscMCE_ Nothing

-- | Variant oscillator constructor with MCE collapsing input.
mkOscMCEId :: UGenId -> Rate -> Name -> [UGen] -> UGen -> Int -> UGen
mkOscMCEId z = mkOscMCE_ (Just z)

mkFilter_ :: Maybe UGenId -> Name -> [UGen] -> Int -> UGen
mkFilter_ z c i o = mkUGen r c i o' (Special 0) z
    where r = maximum (map rateOf i)
          o'= replicate o r

-- | Filter UGen constructor.
mkFilter :: Name -> [UGen] -> Int -> UGen
mkFilter = mkFilter_ Nothing

-- | Filter UGen constructor.
mkFilterId :: UGenId -> Name -> [UGen] -> Int -> UGen
mkFilterId z = mkFilter_ (Just z)

-- | Variant filter with rate derived from keyed input.
mkFilterKeyed :: Name -> Int -> [UGen] -> Int -> UGen
mkFilterKeyed c k i o = mkUGen r c i o' (Special 0) Nothing
    where r = rateOf (i !! k)
          o' = replicate o r

-- | Variant filter constructor with MCE collapsing input.
mkFilterMCE :: Name -> [UGen] -> UGen -> Int -> UGen
mkFilterMCE c i j o = mkFilter c (i ++ mceChannels j) o

-- | Lifting UGenId requiring UGens to UId
liftU :: (UId m) => (UGenId -> a -> UGen) -> (a -> m UGen)
liftU f a = do n <- generateUId
               return (f (UGenId n) a)

liftU2 :: (UId m) => (UGenId -> a -> b -> UGen) -> (a -> b -> m UGen)
liftU2 f a b = do n <- generateUId
                  return (f (UGenId n) a b)

liftU3 :: (UId m) => (UGenId -> a -> b -> c -> UGen) -> (a -> b -> c -> m UGen)
liftU3 f a b c = do n <- generateUId
                    return (f (UGenId n) a b c)

liftU4 :: (UId m) => (UGenId -> a -> b -> c -> d -> UGen) -> (a -> b -> c -> d -> m UGen)
liftU4 f a b c d = do n <- generateUId
                      return (f (UGenId n) a b c d)

