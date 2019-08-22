{-# LANGUAGE DeriveGeneric #-}

module Api.Data
  ( Document(..)
  )
where

import GHC.Generics
import Database.PostgreSQL.ORM.Model
import qualified Data.Text as T

data Document = Document
  { id :: DBKey
  , uuid :: Integer
  , language :: T.Text
  , content :: T.Text } deriving (Show, Generic)

instance Model Document

