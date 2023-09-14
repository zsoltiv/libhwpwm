libhwpwm(3)

# NAME

libhwpwm.h - Control PWM chips from userspace

# OVERVIEW

The *libhwpwm* library provides a thin layer of abstraction for interacting
with PWM hardware using the Linux kernel's /sys filesystem.

# INTERACTING WITH PWM HARDWARE

To interact with a PWM chip, you have to open it using the
*hwpwm\_chip\_open\_index()* function.

Then, you need to export one or more PWM channels with *hwpwm\_chip\_export\_channel()*.
Now you can use the *hwpwm\_channel\_get\_\** and *hwpwm\_set\_\** family of functions to
get/set the duty cycle, the period and the polarity of the PWM signal.

# RETURN VALUES

Functions that return a pointer may return *NULL* if the allocation fails.
The *hwpwm\_chip\_\** family of functions may fail, so you should call
*hwpwm\_chip\_get\_error()* after each call to these functions.

# SEE ALSO

*hwpwm\_chip\_open\_index(3)*
*hwpwm\_chip\_open\_index(3)*
*hwpwm\_chip\_get\_channel\_count(3)*
*hwpwm\_chip\_get\_error(3)*
*hwpwm\_chip\_close(3)*
*hwpwm\_chip\_export\_channel(3)*
*hwpwm\_chip\_unexport\_channel(3)*
*hwpwm\_channel\_get\_period(3)*
*hwpwm\_channel\_get\_duty\_cycle(3)*
*hwpwm\_channel\_get\_polarity(3)*
*hwpwm\_channel\_get\_enable(3)*
*hwpwm\_channel\_set\_period(3)*
*hwpwm\_channel\_set\_period\_frequency(3)*
*hwpwm\_channel\_set\_duty\_cycle(3)*
*hwpwm\_channel\_set\_duty\_cycle\_percent(3)*
*hwpwm\_channel\_set\_polarity(3)*
*hwpwm\_channel\_set\_enable(3)*

# AUTHORS

The *libhwpwm* library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
