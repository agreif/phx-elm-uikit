module Common exposing (
         NavData
       , navDecoder
       )

import Json.Decode as J

type alias NavData =
  {
    items : List NavItem
  }

type alias NavItem =
  {
    label : String,
    active : Bool
  }

navDecoder : J.Decoder NavData
navDecoder =
  J.map NavData
  (J.list navItemDecoder)

navItemDecoder : J.Decoder NavItem
navItemDecoder =
  J.map2 NavItem
  (J.field "label" J.string)
  (J.field "active" J.bool)

