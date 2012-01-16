{-# LANGUAGE OverloadedStrings #-}

module ParaTwist.Warp (
    runTwister
) where

import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200, status400, Query)
import Blaze.ByteString.Builder (copyByteString)
import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import ParaTwist.Types
import ParaTwist.MongoDB as PTM
import Data.Maybe (fromJust)
import Foreign.Marshal

runTwister :: WarpSettings -> IO ()
runTwister settings = do
    let port = warpPort settings
    putStrLn $ "Listening on port " ++ show port
    run port app

app :: Monad m => Request -> m Response
app req = return $
    case pathInfo req of
        ["adeven"] -> unsafeLocalState $ putImpression $ queryString req
        _          -> res $ BU.fromString "400"

res :: BU.ByteString -> Response
res code
    | code == "200" = ResponseBuilder status200 [("Content-Type", "text/plain")] $ resBuilder code
    | otherwise = ResponseBuilder status400 [("Content-Type", "text/plain")] $ resBuilder "400"

resBuilder code = mconcat $ map copyByteString [ code ]

stringifyQuery :: Network.HTTP.Types.Query -> [String]
stringifyQuery (x:xs) = [ v | v <- BU.toString $ fromJust(snd x) ] : stringifyQuery xs
stringifyQuery []     = [""]

putImpression :: Network.HTTP.Types.Query -> IO Response
putImpression paraList = do
    result <- PTM.runMongoInsert $ stringifyQuery $ paraList
    print result
    return $ res $ BU.fromString "200"

