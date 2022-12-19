module ErrorPage exposing (errorPageView)

import Browser
import Common exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


errorPageView : String -> Browser.Document Msg
errorPageView message =
    { title = "error", body = [ text message ] }
