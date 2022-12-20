module ProfilePage exposing (profilePageView)

import Browser
import Common exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as J


profilePageView : ProfilePageData -> Browser.Document Msg
profilePageView data =
    let
        page =
            data.profile
    in
    pageView
        data.title
        data.nav
        [ h2 []
            [ text data.title ]
        , b [] [ text "text1: " ]
        , span [] [ text page.text1 ]
        , hr [] []
        , b [] [ text "text2: " ]
        , span [] [ text page.text2 ]
        ]
