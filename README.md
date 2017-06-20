# Elm state button

Elm state button based on a small state machine.

## Example

```html
<div id="state-button"></div>

<script type="text/javascript">
  // initialize state button
  var element = document.getElementById("state-button");

  var flags = {
    start: { text: 'Start', icon: 'glyphicon glyphicon-send', style: 'btn btn-primary' },
    process: { text: 'Process', icon: 'glyphicon glyphicon-time', style: 'btn btn-default' },
    succeed: { text: 'Succeed', icon: 'glyphicon glyphicon-ok', style: 'btn btn-success' },
    failure: { text: 'Failure', icon: 'glyphicon glyphicon-remove', style: 'btn btn-danger' }
  }

  var stateButton = Elm.Main.embed(element, flags);

  // inspect console for events
  stateButton.ports.change.subscribe(function(state) {
    console.log(state);
  });

  stateButton.ports.error.subscribe(function(error) {
    console.error(error);
  });

  // emit state changes (start -> process -> succeed)
  stateButton.ports.state.send('process')
  stateButton.ports.state.send('succeed')
</script>
```

## State machine model
```basic
                     -> succeed (final)
                   /
start -> process -
  ^                \
  |                  -> failure -
  |                               |
    - - - - - - - - - - - - - - -
```



### Demo

A live demo is available under misc/demo.html

### Install

Install project dependencies.

`npm install`

### Test

Run unit tests with [elm-test](http://package.elm-lang.org/packages/elm-community/elm-test/latest)

`npm test`

### Build
Build main.js library file

`npm run build`

### Clean

Remove project dependencies and builds.

`npm run clean`

### Licence
MIT License

