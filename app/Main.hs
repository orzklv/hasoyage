{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Aeson
import Data.Text (Text)
import Data.Text.IO qualified as T
import GHC.Generics
import Network.Wreq

data TranslateRequest = TranslateRequest
  { q :: Text,
    source :: Text,
    target :: Text,
    format :: Text
  }
  deriving (Generic)

instance ToJSON TranslateRequest

newtype TranslateResponse = TranslateResponse
  { translatedText :: Text
  }
  deriving (Generic)

instance FromJSON TranslateResponse

main :: IO ()
main = do
  rsp <-
    asJSON
      =<< post
        "https://translate.terraprint.co/translate"
        ( toJSON
            ( TranslateRequest
                { q = "This is a test from haskell",
                  source = "en",
                  target = "ru",
                  format = "text"
                }
            )
        )

  T.putStrLn (translatedText (rsp ^. responseBody))
