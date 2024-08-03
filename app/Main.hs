{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Concurrent.Async
import Control.Lens
import Data.Aeson
import Data.Text (Text, pack)
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

data Language = Language
  { code :: Text,
    name :: Text
  }
  deriving (Show, Generic)

instance FromJSON Language

main :: IO ()
main = do
  lngs <- getLanguages

  print "What's the text that you want to translate: "
  text <- getLine

  results <- forConcurrently lngs $ \lang -> do
    rest <- translateText "en" (pack text) (code lang)
    pure (name lang <> ": " <> rest)

  mapM_ T.putStrLn results

getLanguages :: IO [Language]
getLanguages = do
  rsp <- asJSON =<< get "https://translate.terraprint.co/languages"
  pure (rsp ^. responseBody)

translateText :: Text -> Text -> Text -> IO Text
translateText sourceLang text targetLang = do
  rsp <-
    asJSON
      =<< post
        "https://translate.terraprint.co/translate"
        ( toJSON
            ( TranslateRequest
                { q = text,
                  source = sourceLang,
                  target = targetLang,
                  format = "text"
                }
            )
        )
  pure (translatedText (rsp ^. responseBody))
