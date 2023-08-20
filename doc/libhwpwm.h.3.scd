libhwpwm(3)

# NAME

libhwpwm.h - Control PWM chips from userspace

# OVERVIEW

The _libhwpwm_ library provides a thin layer of abstraction for interacting
with PWM hardware using the Linux kernel's /sys filesystem.

# INTERACTING WITH PWM HARDWARE

To interact with a PWM chip, you have to open it using the
_hwpwm\_chip\_open\_index()_ function.

Then, you need to export one or more PWM channels with _hwpwm\_chip\_export\_channel()_.
Now you can use the _hwpwm\_channel\_get\_\*_ and _hwpwm\_set\_\*_ family of functions to
get/set the duty cycle, the period and the polarity of the PWM signal.

# RETURN VALUES

Functions that return a pointer may return _NULL_ if the allocation fails.
The _hwpwm\_chip\_\*_ family of functions may fail, so you should call
_hwpwm\_chip\_get\_error()_ after each call to these functions.

# SEE ALSO

_hwpwm\_chip\_open\_index(3)_ 
_hwpwm\_chip\_open\_index(3)_
_hwpwm\_chip\_get\_channel\_count(3)_
_hwpwm\_chip\_get\_error(3)_
_hwpwm\_chip\_close(3)_
_hwpwm\_chip\_export\_channel(3)_
_hwpwm\_chip\_unexport\_channel(3)_
_hwpwm\_channel\_get\_period(3)_
_hwpwm\_channel\_get\_duty\_cycle(3)_
_hwpwm\_channel\_get\_polarity(3)_
_hwpwm\_channel\_get\_enable(3)_
_hwpwm\_channel\_set\_period(3)_
_hwpwm\_channel\_set\_duty\_cycle(3)_
_hwpwm\_channel\_set\_polarity(3)_
_hwpwm\_channel\_set\_enable(3)_

# AUTHORS

The _libhwpwm_ library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
