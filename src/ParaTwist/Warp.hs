{-# LANGUAGE OverloadedStrings #-}

module ParaTwist.Warp (
    runTwister
) where

import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200, status400)
import Blaze.ByteString.Builder (copyByteString)
import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import Data.Enumerator (run_, enumList, ($$))
import ParaTwist.Types
import ParaTwist.MongoDB

runTwister :: WarpSettings -> IO ()
runTwister settings = do
    let port = warpPort settings
    putStrLn $ "Listening on port " ++ show port
    run port app

app :: Monad m => Request -> m Response
app req = return $
    case pathInfo req of
        ["adeven"] -> getParams $ queryString req
        x -> res400

res400 :: Response
res400 = ResponseBuilder status400 [ ("Content-Type", "text/plain") ]
        $ mconcat
        $ map copyByteString [ "400" ]

getParams :: Show a => a -> Response
getParams paraString = ResponseBuilder status200 [("Content-Type", "text/html")]
        $ mconcat
        $ map copyByteString [ BU.fromString $ show paraString ]

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

