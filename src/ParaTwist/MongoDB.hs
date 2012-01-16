{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}

module ParaTwist.MongoDB (
    runMongoInsert
) where

import Database.MongoDB
import ParaTwist.Types

dbsettings :: DatabaseSettings
dbsettings = DatabaseSettings {
        hostName          = "1.app.over9000.org",
        portNumber        = 27017,
        databaseName      = "adeven",
        collectionName    = "rawRecords"
        }

runMongoInsert :: [String] -> IO (Either Failure Value)
runMongoInsert doc = do
    pipe <- runIOE $ connect $ host $ unpack $ hostName dbsettings
    e <- access pipe master (databaseName dbsettings) $ runInsert $ mongoField doc
    close pipe
    return e

runInsert :: [Field] -> Action IO Value
runInsert doc = do
    --clearCollection
    insertDocument doc

mongoField :: [String] -> [Field]
mongoField list = [
    "uid"         =: list !! 0,
    "countryId"   =: list !! 1,
    "device"      =: list !! 2,
    "campaignId"  =: list !! 3,
    "sourceId"    =: list !! 4
    ]

insertDocument :: [Field] -> Action IO Value
insertDocument doc = insert (collectionName dbsettings) doc

