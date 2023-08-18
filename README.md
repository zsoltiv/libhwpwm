# libhwpwm

An easy to use interface to communicate with the Linux kernel's sysfs PWM interface.

## What it doesn't do

Interacting with PWM chips requires root access, which libhwpwm __doesn't handle__. It merely abstracts away the sysfs interface.

## Documentation

libhwpwm is documented using man-pages.

## Requirements

- POSIX compatible system
- make
- C11 compiler
