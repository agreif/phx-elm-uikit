module ProfilePage exposing
    ( ProfileData
    , genProfileData
    , profilePageView
    )

import Browser
import Common exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as J


type alias ProfileData =
    { title : String
    , nav : NavData
    }


genProfileData : Result String ProfileData
genProfileData =
    let
        json =
            """{
      "title": "Profile Page",
      "nav":
      [
        {
          "label": "Home",
          "url": "home",
          "active": false
        },
        {
          "label": "Profile",
          "url": "profile",
          "active": true
        }
      ]
  }"""
    in
    case J.decodeString pageDecoder json of
        Ok data ->
            Ok data

        Err jsonError ->
            Err (J.errorToString jsonError)


pageDecoder : J.Decoder ProfileData
pageDecoder =
    J.map2 ProfileData
        (J.field "title" J.string)
        (J.field "nav" navDecoder)


profilePageView : ProfileData -> Browser.Document Msg
profilePageView data =
    { title = data.title
    , body =
        [ div [ class "uk-container uk-margin-left" ]
            [ navView
                data.nav
            , h2 []
                [ text data.title ]
            ]
        ]
    }
