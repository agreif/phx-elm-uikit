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
    , page : PageData
    }


type alias PageData =
    { text1 : String
    , text2 : String
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
      ],
      "page": {
        "home": null,
        "profile": {
          "text1": "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
          "text2": "Some other text"
        }
      }
  }"""
    in
    case J.decodeString dataDecoder json of
        Ok data ->
            Ok data

        Err jsonError ->
            Err (J.errorToString jsonError)


dataDecoder : J.Decoder ProfileData
dataDecoder =
    J.map3 ProfileData
        (J.field "title" J.string)
        (J.field "nav" navDecoder)
        (J.field "page" (J.field "profile" pageDecoder))


pageDecoder : J.Decoder PageData
pageDecoder =
    J.map2 PageData
        (J.field "text1" J.string)
        (J.field "text2" J.string)


profilePageView : ProfileData -> Browser.Document Msg
profilePageView data =
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
            , b [] [ text "text1: " ]
            , span [] [ text page.text1 ]
            , hr [] []
            , b [] [ text "text2: " ]
            , span [] [ text page.text2 ]
            ]
        ]
    }
