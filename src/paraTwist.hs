{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}

-----------------------------------------------------------------------------
--
-- Module      :  ParaTwist
-- Copyright   :  (who?!)
-- License     :  AllRightsReserved
--
-- Maintainer  :  Matthias Krull
-- Stability   :  unstable
--
-----------------------------------------------------------------------------

module Main (
    main
) where

import Control.Monad.Trans (liftIO)
import ParaTwist.Types
import ParaTwist.Warp

warpSettings :: WarpSettings
warpSettings = WarpSettings {
    warpPort = 3000
    }

main :: IO ()
main = ParaTwist.Warp.runTwister warpSettings

