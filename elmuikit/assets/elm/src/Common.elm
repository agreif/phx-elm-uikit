module Common exposing
    ( Msg(..)
    , NavData
    , navDecoder
    , navView
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


navView : NavData -> List (Html Msg)
navView data =
    [ h2 [] [ text "Navigation" ]
    , ul []
        (List.map navItemViewLink data.items)
    ]


navItemViewLink : NavItem -> Html Msg
navItemViewLink item =
    case item.active of
        True ->
            li [] [ text item.label ]

        False ->
            li [] [ a [ href item.url ] [ text item.label ] ]
