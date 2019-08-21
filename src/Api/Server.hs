module Api.Server
  (
  )
where

import Servant
import Api.Data

type Id = Integer

type Api
  -- To create a new document: POST /document
  = "document"
    :> ReqBody '[JSON] Document
    :> Post '[JSON] Id
  -- To get a document: GET /:id
  :<|> Capture "id" Id
       :> Get '[JSON] Document

server :: Server Api
server = newDoc :<|> getDoc

-- POST /document
newDoc :: Document -> Handler Id

-- GET /:id
getDoc :: Id -> Handler Document
