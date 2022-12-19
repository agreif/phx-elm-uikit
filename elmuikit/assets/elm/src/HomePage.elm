module HomePage exposing
    ( HomeData
    , genHomeData
    , homePageView
    )

import Browser
import Common exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as J


type alias HomeData =
    { title : String
    , nav : NavData
    }


genHomeData : Result String HomeData
genHomeData =
    let
        json =
            """{
      "title": "Home Page",
      "nav":
      [
        {
          "label": "Home",
          "url": "home",
          "active": true
        },
        {
          "label": "Profile",
          "url": "profile",
          "active": false
        }
      ]
  }"""
    in
    case J.decodeString pageDecoder json of
        Ok data ->
            Ok data

        Err jsonError ->
            Err (J.errorToString jsonError)


pageDecoder : J.Decoder HomeData
pageDecoder =
    J.map2 HomeData
        (J.field "title" J.string)
        (J.field "nav" navDecoder)


homePageView : HomeData -> Browser.Document Msg
homePageView data =
    { title = data.title
    , body =
        [ h1 [] [ text data.title ] ]
            ++ navView data.nav
    }
