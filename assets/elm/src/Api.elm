module Api exposing (Auth, makeQuery)

{-| This module is responsible for communicating to the API.

It exposes an opaque Endpoint type which is guaranteed to point to the correct URL.

-}

import Api.OnlineOps.Object exposing (UserPayload, ValidationMessage)
import Api.OnlineOps.Object.UserPayload as UserPayload
import Api.OnlineOps.Object.ValidationMessage as ValidationMessage
import Browser
import Browser.Navigation as Nav
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Http exposing (Body, Expect)
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline as Pipeline exposing (optional, required)
import Json.Encode as Encode
import Url exposing (Url)


type alias RawError =
    { code : String
    , field : Maybe String
    , message : Maybe String
    }


type alias ErrorDetails =
    { field : String
    , message : String
    }


type ErrorMessage
    = NotFound
    | TokenError
    | ExpiredToken
    | Unauthorized ErrorDetails
    | InvalidInput ErrorDetails


type ErrorMessages
    = None
    | Errors (List ErrorMessage)


type Response a
    = Response
        { successful : Bool
        , result : a
        , messages : Maybe (List ErrorMessage)
        }


type alias Profile =
    { firstName : String
    , lastName : String
    }


endpoint : String
endpoint =
    "http://localhost:4000/graphql"


getAuthHeader : Auth -> (Graphql.Http.Request decodesTo -> Graphql.Http.Request decodesTo)
getAuthHeader (Auth token) =
    Graphql.Http.withHeader "Authorization" ("Bearer " ++ token)


makeQuery : Auth -> SelectionSet decodesTo RootQuery -> (Result (Graphql.Http.Error decodesTo) decodesTo -> msg) -> Cmd msg
makeQuery auth query decodesTo =
    query
        |> Graphql.Http.queryRequest endpoint
        |> getAuthHeader auth
        |> Graphql.Http.send decodesTo


userPayload : SelectionSet (Response Profile) UserPayload
userPayload =
    SelectionSet.map3 Response
        (UserPayload.messages (SelectionSet.list messageSelection))
        UserPayload.result
        UserPayload.successful


messageSelection : SelectionSet ErrorMessage ValidationMessage
messageSelection =
    SelectionSet.map3 RawError
        ValidationMessage.code
        ValidationMessage.field
        ValidationMessage.message
        |> SelectionSet.map processError


processError : RawError -> ErrorMessage
processError _ =
    NotFound


getResult : Response a -> Result ErrorMessages a
getResult (Response { successful, result, messages }) =
    if successful then
        Ok result

    else
        Err messages



-- CRED


{-| The authentication credentials for the Viewer (that is, the currently logged-in user.)
This includes:

  - The cred's authentication token
    By design, there is no way to access the token directly as a String.
    It can be encoded for persistence, and it can be added to a header
    to a HttpBuilder for a request, but that's it.
    This token should never be rendered to the end user, and with this API, it
    can't be!

-}
type Auth
    = Auth String
