module ProfilePage exposing
       ( ProfileData
       , genProfileData
       )

import Json.Decode as J
import Common exposing (..)

type alias ProfileData =
  { title : String,
    nav : NavData
  }

genProfileData : Result String ProfileData
genProfileData =
  let
    json =
      """{
      "title": "Home Page",
      "nav":
      [
        {
          "label": "Home",
          "active": false
        },
        {
          "label": "Profile",
          "active": true
        }
      ]
  }"""
  in
    case J.decodeString pageDecoder json of
      Ok data -> Ok data
      Err jsonError -> Err (J.errorToString jsonError)

pageDecoder : J.Decoder ProfileData
pageDecoder =
  J.map2 ProfileData
  (J.field "title" J.string)
  (J.field "nav" navDecoder)
