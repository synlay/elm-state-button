# Elm state button

Elm state button based on a simple state machine.

### State machine model
```basic
                      -> Succeed (final)
                    /
Start -> Process ->
  ^                 \
  |                   -> Failure -
  |                                |
    - - - - - - - - - - - - - - - -
```

### Install

Install project dependencies for testing and demo.

`npm install`

### Test

Run unit tests with [elm-test](http://package.elm-lang.org/packages/elm-community/elm-test/latest)

`npm test`

### Build

Build project app and demo client

`npm run build`

### Clean

Remove project dependencies and builds.

`npm run clean`

### Usage

See `docs/Client.elm` for Elm integration and `docs/demo.html` for JavaScript integration. Additionally you could start the demo.

### Demo

Starts a http server for demonstration purpose. Navigate to `http://localhost:8000/docs/demo.html`

`npm run demo`


### Licence
MIT License
