{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}

module ParaTwist.MongoDB (
    doMongo,
    makeConnection,
    closeConnection
) where

import Database.MongoDB as DM
import Data.Binary
import qualified Data.ByteString.Lazy as BS

import ParaTwist.Types

dbsettings :: DatabaseSettings
dbsettings = DatabaseSettings {
        hostName          = "1.app.over9000.org",
        portNumber        = 27017,
        databaseName      = "adeven",
        collectionName    = "rawRecords",
        batchSize'        = 10,
        serializeFile     = "/tmp/paratwist.bin"
        }

makeConnection :: IO Pipe
makeConnection = do
    pipe <- runIOE $ connect $ host $ DM.unpack $ hostName dbsettings
    return pipe

closeConnection :: Pipe -> IO ()
closeConnection pipe = close pipe

checkBatchSize :: [[String]] -> Bool
checkBatchSize batch =
    if (length batch) >= batchSize' dbsettings
        then True
        else False

doMongo :: Pipe -> [String] -> IO Bool
doMongo mongoConn doc = do
    saved <- deserialize
    let batch = saved ++ [doc]
    case checkBatchSize batch of
        True  -> do
            _ <- runMongoInsert' mongoConn batch
            return True
        False -> do
            io <- serialize batch
            print io
            return False

runMongoInsert' :: Pipe -> [[String]] -> IO (Either Failure [Value])
runMongoInsert' mongoConn doc = do
    e <- access mongoConn master (databaseName dbsettings) $ runBatchInsert $ mongoBatch doc
    serialize []
    return e

runBatchInsert :: [[Field]] -> Action IO [Value]
runBatchInsert docs = do
    insertMany (collectionName dbsettings) docs

mongoField :: [String] -> [Field]
mongoField list = [
    "uid"         =: list !! 0,
    "countryId"   =: list !! 1,
    "device"      =: list !! 2,
    "campaignId"  =: list !! 3,
    "sourceId"    =: list !! 4
    ]

mongoBatch :: [[String]] -> [[Field]]
mongoBatch []     = []
mongoBatch (x:xs) = [ doc | doc <- mongoField x ] : mongoBatch xs

toBinary :: Data.Binary.Binary a => a -> BS.ByteString
toBinary dat = Data.Binary.encode dat

fromBinary :: BS.ByteString -> [[String]]
fromBinary bs = Data.Binary.decode bs

serialize :: [[String]] -> IO ()
serialize dat = do
    let binary = toBinary dat
    io <- BS.writeFile (DM.unpack $ serializeFile dbsettings) binary
    print io

deserialize :: IO [[String]]
deserialize = do
    binary <- BS.readFile $ DM.unpack $ serializeFile dbsettings
    print binary
    return $ fromBinary binary

