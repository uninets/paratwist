{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}

module ParaTwist.MongoDB (
    runMongoInsert,
    makeConnection,
    closeConnection
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

makeConnection :: IO Pipe
makeConnection = do
    pipe <- runIOE $ connect $ host $ unpack $ hostName dbsettings
    return pipe

closeConnection :: Pipe -> IO ()
closeConnection pipe = close pipe

runMongoInsert :: Pipe -> [String] -> IO (Either Failure Value)
runMongoInsert mongoConn doc = do
    e <- access mongoConn master (databaseName dbsettings) $ runInsert $ mongoField doc
    return e

runInsert :: [Field] -> Action IO Value
runInsert doc = do
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

