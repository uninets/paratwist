{-# LANGUAGE OverloadedStrings #-}

module ParaTwist.Warp (
    runTwister
) where

import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200, status400, Query, QueryItem)
import Blaze.ByteString.Builder (copyByteString, Builder)

import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import Data.Maybe (fromJust)
import Foreign.Marshal

import ParaTwist.Types
import Database.MongoDB
import ParaTwist.MongoDB as PTM

runTwister :: WarpSettings -> IO ()
runTwister settings = do
    let port = warpPort settings
    mongoConn <- PTM.makeConnection
    putStrLn $ "Listening on port " ++ show port
    run port (app mongoConn)

app :: Monad m => Pipe -> Request -> m Response
app mongoConn req = return $
    case pathInfo req of
        ["adeven"] -> unsafeLocalState $ putImpression mongoConn $ queryString req
        _          -> res $ BU.fromString "400"

res :: BU.ByteString -> Response
res code
    | code == "200" = ResponseBuilder status200 [("Content-Type", "text/plain")] $ resBuilder code
    | otherwise = ResponseBuilder status400 [("Content-Type", "text/plain")] $ resBuilder "400"

resBuilder :: BU.ByteString -> Builder
resBuilder code = mconcat $ map copyByteString [ code ]

paraKey :: Network.HTTP.Types.QueryItem -> String
paraKey (k,_) = BU.toString k

paraValue :: Network.HTTP.Types.QueryItem -> String
paraValue (_,v) = BU.toString $ fromJust v

queryToValueList :: Network.HTTP.Types.Query -> [(String,String)]
queryToValueList xs = [ (paraKey x,paraValue x) | x <- xs ]

putImpression :: Pipe -> Network.HTTP.Types.Query -> IO Response
putImpression mongoConn paraList = do
    result <- PTM.runMongoInsert mongoConn $ queryToValueList paraList
    case result of
        Right _ -> return $ res $ BU.fromString "200"
        Left _ -> return $ res $ BU.fromString "400"

