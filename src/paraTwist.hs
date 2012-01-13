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

dbsettings :: DatabaseSettings
dbsettings = DatabaseSettings {
        hostName          = "1.app.over9000.org",
        portNumber        = 27017,
        databaseName      = "adeven",
        collectionName    = "rawRecords"
        }

adevenImpression :: AdevenImression
adevenImpression = AdevenImression {
        uid         = "1234567890abcdefghijklmnopqrstuvwxyz1234",
        countryId   = "1a",
        device      = "android",
        campaignId  = "active",
        sourceId    = "webseiteXYZ"
        }

warpSettings :: WarpSettings
warpSettings = WarpSettings {
    warpPort = 3000
    }

main :: IO ()
main = ParaTwist.Warp.runTwister warpSettings

