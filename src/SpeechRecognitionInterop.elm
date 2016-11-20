module SpeechRecognitionInterop exposing (Alternative, Result, Event)

{-| Types for an interop between Elm and the HTML5 SpeechRecognition API.

# Definition
@docs Alternative, Result, Event
-}


{-| https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognitionAlternative
-}
type alias Alternative =
    { transcript : String
    , confidence : Float
    }


{-| https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognitionResult
-}
type alias Result =
    { isFinal : Bool
    , items : List Alternative
    }


{-| https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognitionEvent
-}
type alias Event =
    { resultIndex : Int
    , results : List Result
    }
