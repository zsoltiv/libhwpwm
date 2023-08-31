# libhwpwm

An easy to use library to communicate with the Linux kernel's sysfs PWM interface.

## Documentation

libhwpwm is documented using man-pages. See `man 3 libhwpwm.h`

## Requirements

- A Linux system
- make
- C99 compiler
- scdoc for generating man-pages

## Accessing PWMs without root

libhwpwm only exposes the sysfs interface as an easy to use C API, it does not
handle permissions.

In order to run programs that use libhwpwm without being root, you can use a
[udev rule](https://man7.org/linux/man-pages/man7/udev.7.html) like this:

```
SUBSYSTEM=="pwm", MODE="0666"
```

This rule would allow any user to run programs using this library.

### Warning

It's probably not a good idea to grant global R/W access to sysfs nodes.
