port module Example exposing (..)

import Html exposing (Html, text, button, div)
import Html.App as App
import Html.Events exposing (onClick)
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
    | Start


getLatestResult : Speech.Event -> Maybe Speech.Result
getLatestResult event =
    event.results |> Array.fromList |> Array.get event.resultIndex


getItemsFromResult : Maybe Speech.Result -> Maybe (List Speech.Alternative)
getItemsFromResult result =
    result |> Maybe.map .items |> Maybe.map reverse


getTranscript : Maybe Speech.Result -> Maybe String
getTranscript result =
    Maybe.andThen (getItemsFromResult result) head
        |> Maybe.map .transcript


latestTranscript : Speech.Event -> Maybe String
latestTranscript event =
    log "event" event |> getLatestResult |> getTranscript


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change speechEvent ->
            ( { model | text = latestTranscript speechEvent }, Cmd.none )

        Start ->
            ( model, state "start" )


port state : String -> Cmd msg


port events : (Speech.Event -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    events Change


view : Model -> Html Msg
view model =
    div
        []
        [ text <| Maybe.withDefault "Not recognized" model.text
        , button [ onClick Start ] [ text "Start" ]
        ]
