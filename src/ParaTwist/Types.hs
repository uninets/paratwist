module ParaTwist.Types where

import Data.CompactString.Internal as DCSI
import Data.CompactString.Encodings as DCSE

data DatabaseSettings = DatabaseSettings {
        hostName       :: DCSI.CompactString DCSE.UTF8,
        portNumber     :: Int,
        databaseName   :: DCSI.CompactString DCSE.UTF8,
        batchSize'     :: Int,
        serializeFile  :: DCSI.CompactString DCSE.UTF8,
        collectionName :: DCSI.CompactString DCSE.UTF8
        }

data WarpSettings = WarpSettings {
        warpPort :: Int
        }

