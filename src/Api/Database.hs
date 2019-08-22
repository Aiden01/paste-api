module Api.Database
  ( HasConnection
  , getConn
  , withConn
  )
where

import Database.PostgreSQL.Simple
import Control.Monad.IO.Class

class HasConnection m where
  getConn :: m Connection

withConn :: (MonadIO m, HasConnection m) => (Connection -> IO a) -> m a
withConn f = getConn >>= liftIO . f
