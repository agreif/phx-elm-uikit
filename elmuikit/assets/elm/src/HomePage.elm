module HomePage exposing
       ( HomeData
       , genHomeData
       )

import Json.Decode as J
import Common exposing (..)

type alias HomeData =
  { title : String,
    nav : NavData
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
          "active": true
        },
        {
          "label": "Profile",
          "active": false
        }
      ]
  }"""
  in
    case J.decodeString pageDecoder json of
      Ok data -> Ok data
      Err jsonError -> Err (J.errorToString jsonError)

pageDecoder : J.Decoder HomeData
pageDecoder =
  J.map2 HomeData
  (J.field "title" J.string)
  (J.field "nav" navDecoder)
