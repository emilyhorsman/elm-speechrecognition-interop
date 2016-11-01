module SpeechRecognitionInterop exposing (Alternative, Result, Event)


type alias Alternative =
    { transcript : String
    , confidence : Float
    }


type alias Result =
    { isFinal : Bool
    , items : List Alternative
    }


type alias Event =
    { resultIndex : Int
    , results : List Result
    }
