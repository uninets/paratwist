module ParaTwist.Types where

import Data.CompactString.Internal as DCSI
import Data.CompactString.Encodings as DCSE

data DatabaseSettings = DatabaseSettings {
        hostName       :: DCSI.CompactString DCSE.UTF8,
        portNumber     :: Int,
        databaseName   :: DCSI.CompactString DCSE.UTF8,
        collectionName :: DCSI.CompactString DCSE.UTF8
        }

-- uid = 40byte (ASCII) poolsize = 200M
-- countryId = 2byte (ISO-CODE) poolsize=140
-- device = 10byte poolsize=40
-- campaignId = 6byte (ASCII) poolsize=10
-- sourceId = 20byte (ASCII) poolsize=1000
data AdevenImression = AdevenImression {
        uid         :: DCSI.CompactString DCSE.UTF8,
        countryId   :: DCSI.CompactString DCSE.UTF8,
        device      :: DCSI.CompactString DCSE.UTF8,
        campaignId  :: DCSI.CompactString DCSE.UTF8,
        sourceId    :: DCSI.CompactString DCSE.UTF8
        }
