module Common exposing
    ( HomeData
    , HomePageData
    , Msg(..)
    , NavData
    , ProfilePageData
    , fetchData
    , homePageDecoder
    , navDecoder
    , navView
    , pageView
    , profilePageDecoder
    )

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as J
import Url



-- MSG


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotProfileData (Result Http.Error ProfilePageData)
    | GotHomeData (Result Http.Error HomePageData)



-- DATA - HOME


type alias HomePageData =
    { title : String
    , nav : NavData
    , home : HomeData
    }


type alias HomeData =
    { body : String
    }


homePageDecoder : J.Decoder HomePageData
homePageDecoder =
    J.map3 HomePageData
        (J.field "title" J.string)
        (J.field "nav" navDecoder)
        (J.field "page" (J.field "home" homeDecoder))


homeDecoder : J.Decoder HomeData
homeDecoder =
    J.map HomeData
        (J.field "body" J.string)



-- DATA - PROFILE


type alias ProfilePageData =
    { title : String
    , nav : NavData
    , profile : ProfileData
    }


type alias ProfileData =
    { text1 : String
    , text2 : String
    }


profilePageDecoder : J.Decoder ProfilePageData
profilePageDecoder =
    J.map3 ProfilePageData
        (J.field "title" J.string)
        (J.field "nav" navDecoder)
        (J.field "page" (J.field "profile" profileDecoder))


profileDecoder : J.Decoder ProfileData
profileDecoder =
    J.map2 ProfileData
        (J.field "text1" J.string)
        (J.field "text2" J.string)



-- NAVIGATION


type alias NavData =
    { items : List NavItem
    }


type alias NavItem =
    { label : String
    , url : String
    , active : Bool
    }


navDecoder : J.Decoder NavData
navDecoder =
    J.map NavData
        (J.list navItemDecoder)


navItemDecoder : J.Decoder NavItem
navItemDecoder =
    J.map3 NavItem
        (J.field "label" J.string)
        (J.field "url" J.string)
        (J.field "active" J.bool)


navView : NavData -> Html Msg
navView data =
    nav
        [ class "uk-navbar-container uk-margin"
        , attribute "uk-navbar" ""
        ]
        [ div
            [ class "uk-navbar-left uk-margin-left"
            ]
            [ a
                [ class "uk-navbar-item uk-logo"
                , href "#"
                ]
                [ text "Phx-Elm" ]
            , ul
                [ class "uk-navbar-nav"
                ]
                (List.map navItemViewLink data.items)
            ]
        , div
            [ class "uk-navbar-right uk-margin-right"
            ]
            []
        ]


navItemViewLink : NavItem -> Html Msg
navItemViewLink item =
    let
        activeClass =
            if item.active then
                "uk-active"

            else
                ""
    in
    li
        [ class activeClass
        ]
        [ a
            [ href item.url
            ]
            [ text item.label ]
        ]



-- PAGE VIEW


pageView : String -> NavData -> List (Html Msg) -> Browser.Document Msg
pageView title nav bodyElems =
    { title = title
    , body =
        [ div [ class "uk-container uk-margin-left" ]
            ([ navView nav ]
                ++ bodyElems
            )
        ]
    }



-- HELPERS


fetchData : Url.Url -> Cmd Msg
fetchData pageUrl =
    case pageUrl.path of
        "/profile" ->
            Http.get
                { url =
                    "https://raw.githubusercontent.com/agreif/phx-elm-uikit/master/sample_page_data/profile_page.json"
                , expect = Http.expectJson GotProfileData profilePageDecoder
                }

        "/home" ->
            Http.get
                { url =
                    "https://raw.githubusercontent.com/agreif/phx-elm-uikit/master/sample_page_data/home_page.json"
                , expect = Http.expectJson GotHomeData homePageDecoder
                }

        _ ->
            Nav.load "/home"
