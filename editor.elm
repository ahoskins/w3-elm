module Editor where

import Html exposing (..)
import Html.Attributes exposing (style, srcdoc, value, rows)
import Html.Events exposing (onClick, on, targetValue)
import List
import Json.Decode as Json

---------- MODEL -------------

type Action = 
    -- union type
      InputChange String 
    | RenderChange

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

update : Action -> Model -> Model
update action model = 
    case action of
        InputChange str ->
            { model |
                input = str
            }
        RenderChange ->
            { model |
                render = model.input
            }

---------- VIEW ---------------

-- root view
view : Signal.Address Action -> Model -> Html
view address model = 
    div 
        []
        [ makeTitle, makeButton address, mainView address model ]


makeInput : Signal.Address Action -> Model -> Html
makeInput address model = 
    textarea 
        -- function composition (InputChange takes a string, address takes Action)
        [ on "input" targetValue (Signal.message address << InputChange) 
        , value model.input
        , rows 20
        , style [("width", "100%")] ] 
        [ ]


makeButton : Signal.Address Action -> Html
makeButton address = 
    button
        [ onClick address RenderChange ]
        [ text "See Result "]


makeTitle : Html
makeTitle = 
    div 
        [ style [("font-size", "2em")]]
        [ text "W3-Elm"]


mainView : Signal.Address Action -> Model -> Html
mainView address model = 
    let editor : Html
        editor = 
            div 
                [ style [("width", "50%"), ("margin-right", "20px")] ] 
                [ makeInput address model ]
        render : Html
        render = 
            div 
                [ style [("width", "50%")] ]
                [ iframe 
                    [ srcdoc model.render
                    , style [("width", "100%")] 
                    ]
                    [ ] 
                ]
    in
        div 
            [ style [("display", "flex"), ("margin", "20px")] ]
            [ editor, render ]

