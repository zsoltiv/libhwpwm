# libhwpwm

An easy to use library to communicate with the Linux kernel's sysfs PWM interface.

## What it doesn't do

Interacting with PWM chips requires root access, which libhwpwm __doesn't handle__. It merely abstracts away the sysfs interface.

## Documentation

libhwpwm is documented using man-pages. See `man 3 libhwpwm.h`

## Requirements

- POSIX compatible system
- make
- C99 compiler
- scdoc for generating man-pages
