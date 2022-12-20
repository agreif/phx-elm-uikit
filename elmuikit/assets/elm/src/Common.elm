module Common exposing
    ( Msg(..)
    , NavData
    , navDecoder
    , navView
    , pageView
    )

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as J
import Url



-- MSG


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url



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
