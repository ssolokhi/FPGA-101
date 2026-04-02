In this project, the state of an LED will be toggled each time a button is pushed.

There are two input signals:
```Verilog
i_clock
i_button
```

and one output signal:
```Verilog
o_toggle_LED
```

The button signal is first passed through a [*debouncing*](https://www.picotech.com/library/articles/blog/what-is-switch-bounce-how-to-implement-debounce)
 module until a stable signal is received.
