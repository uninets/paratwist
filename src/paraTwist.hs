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

import Database.MongoDB
import Control.Monad.Trans (liftIO)
import ParaTwist.Types

dbsettings :: DatabaseSettings
dbsettings = DatabaseSettings {
        hostName            = "1.app.over9000.org",
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

main :: IO ()
main = do
    pipe <- runIOE $ connect $ host $ unpack $ hostName dbsettings
    e <- access pipe master (databaseName dbsettings) runInsert
    close pipe
    print e

runInsert :: Action IO Value
runInsert = do
    clearCollection
    insertDocument

clearCollection = delete (select [] (collectionName dbsettings))

mongoInsert :: [Field]
mongoInsert = [
    "uid"         =: (uid adevenImpression),
    "countryId"   =: (countryId adevenImpression),
    "device"      =: (device adevenImpression),
    "campaignId"  =: (campaignId adevenImpression),
    "sourceId"    =: (sourceId adevenImpression)
    ]

insertDocument :: Action IO Value
insertDocument = insert (collectionName dbsettings) mongoInsert

