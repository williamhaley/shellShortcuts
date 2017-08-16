# Shortcuts

```
Prefix = ctrl-b
```

Hold `alt` key before selecting text to get "normal" copy/paste.

To run a command, hit ctrl+b (then let go) then hit a key.

```
Prefix + c = create new window
Prefix + p = previous window
Prefix + n = next window
Prefix + w = list windows

Prefix + z = zoom out/in on a pane

Prefix + q = list pane numbers
Prefix + left = previous pane
Prefix + right = next pane
Prefix + o = swap panes

Prefix + % = horizontal pane split
Prefix + " = vertical pane split
Prefix + (hold an arrow) = resize pane

Prefix + , = rename window

Prefix + d = disconnect
tmux attach -t SESSION_NUMBER
```

# Resize Pane

Set the width of pane 1 to 100.

```
tmux resize-pane -t 1 -x 100
```

Set the height of pane 2 to 80.

```
tmux resize-pane -t 2 -y 80
```

