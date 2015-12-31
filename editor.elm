module Editor where

import Html exposing (..)
import Html.Attributes exposing (style, srcdoc, value)
import Html.Events exposing (onClick, on, targetValue)
import List
import Json.Decode as Json

---------- MODEL -------------

type Action = 
      InputChange
    | RenderChange

type alias AddressObject = 
    { action: Action
    , value: String
    }

type alias Model = 
    { input: String
    , render: String
    }

init : Model
init = 
    { input = "hello"
    , render = "hello"
    }

---------- UPDATE -------------

update : AddressObject -> Model -> Model
update object model = 
    case object.action of
        InputChange ->
            { model |
                input = object.value
            }
        RenderChange ->
            { model |
                render = model.input
            }

---------- VIEW ---------------

-- root view
view : Signal.Address AddressObject -> Model -> Html
view address model = 
    div 
        []
        [ makeTitle, mainView address model ]


makeInput : Signal.Address AddressObject -> Model -> Html
makeInput address model = 
    input 
        [ on "input" targetValue (\str -> Signal.message address {action = InputChange, value = str}) 
        , value model.input
        , style [("width", "100%")] ] 
        [ ]


makeButton : Signal.Address AddressObject -> Html
makeButton address = 
    button
        [ onClick address {action = RenderChange, value = "empty"} ]
        [ ]


makeTitle : Html
makeTitle = 
    div 
        [ style [("font-size", "2em")]]
        [ text "W3-Elm"]


mainView : Signal.Address AddressObject -> Model -> Html
mainView address model = 
    let editor : Html
        editor = 
            div 
                [ style [("width", "50%")] ] 
                [ makeInput address model
                , makeButton address
                ]
        render : Html
        render = 
            div 
                [ style [("width", "50%")] ]
                [ iframe 
                    [ srcdoc model.render ]
                    [ ] 
                ]
    in
        div 
            [ style [("display", "flex")] ]
            [ editor, render ]

