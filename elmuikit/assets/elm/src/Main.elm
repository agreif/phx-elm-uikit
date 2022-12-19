module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

-- MAIN

main : Program (Maybe String) Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

-- MODEL

type alias Model =
  { key : Nav.Key
  , url : Url.Url
  , page : Page
  }

type Page = HomePage HomeData | ProfilePage ProfileData

type alias HomeData =
  { title : String
  }

type alias ProfileData =
  { title : String
  }


genHomeData : HomeData
genHomeData = {title = "Home Page"}

genProfileData : ProfileData
genProfileData = {title = "Profile Page"}

getPage : Url.Url -> Page
getPage url =
  case url.path of
    "/profile" -> ProfilePage genProfileData
    _ -> HomePage genHomeData


init : Maybe String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeUrlStr url key =
  case maybeUrlStr of
    Just urlStr ->
      case Url.fromString urlStr of
        Just url2 -> ( Model key url2 (getPage url2)
                     , Nav.pushUrl key (Url.toString url2) )
        _ -> ( Model key url (getPage url)
             , Cmd.none )
    _ -> ( Model key url (getPage url)
         , Cmd.none )

-- UPDATE

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )
        Browser.External href ->
          ( model, Nav.load href )
    UrlChanged url ->
      ( { model | url = url, page = getPage url }
      , Cmd.none
      )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- VIEW

view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"
  , body =
      [h1 [] [ text (pageTitle model.page) ]
      , text "The current URL is: "
      , b [] [ text (Url.toString model.url) ]
      , ul []
          [ viewLink "/home"
          , viewLink "/profile"
          , viewLink "https://google.com"
          ]
      ]
  }

pageTitle : Page -> String
pageTitle page =
  case page of
    HomePage data -> data.title
    ProfilePage data -> data.title

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]

