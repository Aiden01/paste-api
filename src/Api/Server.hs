{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}
module Api.Server
  (
  )
where

import Servant
import Api.Data
import Api.Database
import Control.Monad.Reader
import Database.PostgreSQL.Simple
import qualified Data.Text as T

newtype State = State
  { conn :: Connection
  }

type AppM = ReaderT State Handler

instance HasConnection AppM where
  getConn = asks conn

type Id = Integer

data AppResponse a = AppResponse
  { error :: Bool
  , errorMsg :: Maybe T.Text
  , _data :: Maybe a
  }

data DocBody = DocBody
  { language :: T.Text
  , content  :: T.Text
  }

mkError :: T.Text -> AppResponse a
mkError e = AppResponse True (Just e) Nothing

mkResp :: a -> AppResponse a
mkResp = AppResponse False Nothing . Just

type Api
  -- To create a new document: POST /document
  = "document"
    :> ReqBody '[JSON] DocBody
    :> Post '[JSON] (AppResponse Id)
  -- To get a document: GET /:id
  :<|> Capture "id" Id
       :> Get '[JSON] (AppResponse Document)

server :: ServerT Api AppM
server = newDoc :<|> getDoc

-- POST /document
newDoc :: DocBody -> AppM (AppResponse Id)
newDoc (DocBody lang content)
  | content == "" = pure (mkError "Content is empty")
  | lang == "" = pure (mkError "Invalid language")
  | otherwise = do
      let doc = Document NullKey 1 lang content
      newDoc <- withConn (\conn -> save Document conn doc)
      pure (mkResp newDoc)

-- GET /:id
getDoc :: Id -> AppM (AppResponse Document)
getDoc = undefined
