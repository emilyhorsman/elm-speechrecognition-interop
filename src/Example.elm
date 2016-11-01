port module Example exposing (..)

import Html exposing (Html, text)
import Html.App as App
import String
import Array
import Maybe
import List exposing (head, reverse)
import Debug exposing (log)
import SpeechRecognitionInterop as Speech


main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { text : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing, Cmd.none )


type Msg
    = Change Speech.Event


getLatestResult : Speech.Event -> Maybe Speech.Result
getLatestResult event =
    event.results |> Array.fromList |> Array.get event.resultIndex


getTranscript : Maybe Speech.Result -> Maybe String
getTranscript result =
    case result of
        Nothing ->
            Nothing

        Just result ->
            case head (reverse result.items) of
                Nothing ->
                    Nothing

                Just item ->
                    Just (log "thing" item.transcript)


latestTranscript : Speech.Event -> Maybe String
latestTranscript event =
    log "event" event |> getLatestResult |> getTranscript


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change speechEvent ->
            ( { model | text = latestTranscript speechEvent }, Cmd.none )


port events : (Speech.Event -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    events Change


view : Model -> Html Msg
view model =
    case model.text of
        Nothing ->
            text "Not recognized"

        Just t ->
            text t
