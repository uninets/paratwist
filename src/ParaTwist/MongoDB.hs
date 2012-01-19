{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}

module ParaTwist.MongoDB (
    runMongoInsert,
    makeConnection,
    closeConnection
) where

import Database.MongoDB
import ParaTwist.Types
import Data.UString as DUS

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

runMongoInsert :: Pipe -> [(String,String)] -> IO (Either Failure Value)
runMongoInsert mongoConn doc = do
    e <- access mongoConn master (databaseName dbsettings) $ insert (collectionName dbsettings) $ mongoField doc
    return e

mongoSingleField :: Val v => Label -> v -> Field
mongoSingleField k v = k =: v

mongoField :: Val v =>  [(String,v)] -> [Field]
mongoField xs = [ mongoSingleField (DUS.pack (fst x)) (snd x) | x <- xs ]

