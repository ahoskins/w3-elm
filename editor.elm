module Editor where

import Html exposing (..)
import Html.Attributes exposing (style, srcdoc, value)
import Html.Events exposing (onClick, on, targetValue)
import List
import Json.Decode as Json

---------- MODEL -------------

type alias Model = String

init : Model
init = ""

---------- UPDATE -------------

update : Model -> Model -> Model
update newStr oldStr = 
    newStr

---------- VIEW ---------------

-- root view
view : Signal.Address Model -> Model -> Html
view address model = 
    div 
        []
        [makeTitle, mainView address model]


makeInput : Signal.Address Model -> Model -> Html
makeInput address model = 
    input 
        [ on "input" targetValue (Signal.message address) 
        , value model
        , style [("width", "100%")] ] 
        [ ]

makeTitle : Html
makeTitle = 
    div 
        [ style [("font-size", "2em")]]
        [ text "W3-Elm"]

-- first arg is an address that expects an Model type
mainView : Signal.Address Model -> Model -> Html
mainView address model = 
    let editor : Html
        editor = 
            div 
                [ style [("width", "50%")] ] 
                [ makeInput address model ]
        render : Html
        render = 
            -- render the model in the iframe, the model is saved when the button is pressed
            div 
                [ style [("width", "50%")] ]
                [ iframe 
                    [ srcdoc model ]
                    [ ] 
                ]
    in
        div 
            [ style [("display", "flex")] ]
            [ editor, render ]



