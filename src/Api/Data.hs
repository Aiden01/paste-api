module Api.Data
  ( Document(..)
  )
where

data Document = Document
  { id :: Integer
  , uuid :: Integer
  , language :: String
  , content :: String } deriving (Show)

