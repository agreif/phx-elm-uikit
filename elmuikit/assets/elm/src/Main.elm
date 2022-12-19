module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Common exposing (..)
import ErrorPage exposing (..)
import HomePage exposing (..)
import ProfilePage exposing (..)
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
    , page : Page
    }


type Page
    = HomePage HomeData
    | ProfilePage ProfileData
    | ErrorPage String


getPage : Url.Url -> Page
getPage url =
    case url.path of
        "/profile" ->
            case genProfileData of
                Ok data ->
                    ProfilePage data

                Err error ->
                    ErrorPage error

        _ ->
            case genHomeData of
                Ok data ->
                    HomePage data

                Err error ->
                    ErrorPage error


init : Maybe String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeUrlStr url key =
    case maybeUrlStr of
        Just urlStr ->
            case Url.fromString urlStr of
                Just url2 ->
                    ( Model key (getPage url2)
                    , Nav.pushUrl key (Url.toString url2)
                    )

                _ ->
                    ( Model key (getPage url)
                    , Cmd.none
                    )

        _ ->
            ( Model key (getPage url)
            , Cmd.none
            )



-- UPDATE


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
            ( { model | page = getPage url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        HomePage data ->
            homePageView data

        ProfilePage data ->
            profilePageView data

        ErrorPage message ->
            errorPageView message
