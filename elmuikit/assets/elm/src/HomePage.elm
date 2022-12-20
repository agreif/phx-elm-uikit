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
    , page : PageData
    }


type alias PageData =
    { body : String
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
      ],
      "page": {
        "home": {
          "body": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
        },
        "profile": null
      }
  }"""
    in
    case J.decodeString dataDecoder json of
        Ok data ->
            Ok data

        Err jsonError ->
            Err (J.errorToString jsonError)


dataDecoder : J.Decoder HomeData
dataDecoder =
    J.map3 HomeData
        (J.field "title" J.string)
        (J.field "nav" navDecoder)
        (J.field "page" (J.field "home" pageDecoder))


pageDecoder : J.Decoder PageData
pageDecoder =
    J.map PageData
        (J.field "body" J.string)


homePageView : HomeData -> Browser.Document Msg
homePageView data =
    let
        page =
            data.page
    in
    { title = data.title
    , body =
        [ div [ class "uk-container uk-margin-left" ]
            [ navView
                data.nav
            , h2 []
                [ text data.title ]
            , b [] [ text "body: " ]
            , span [] [ text page.body ]
            ]
        ]
    }
