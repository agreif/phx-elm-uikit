module ErrorPage
  exposing ( errorPageView
           )

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Common exposing (..)

errorPageView : String -> Browser.Document Msg
errorPageView message =
  { title = "error", body = [text message] }
