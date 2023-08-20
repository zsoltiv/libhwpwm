hwpwm_chip_get_error(3)

# NAME

_hwpwm\_chip\_get\_error_ - Get the last error set by a _hwpwm\_chip\_\*_ function

# SYNOPSIS

#include <hwpwm.h>

int _hwpwm\_chip\_get\_error_(struct hwpwm\_chip \*chip);

# DESCRIPTION

This function returns the error value from a PWM chip object (set by
_hwpwm\_chip\_\*_ family of functions).

# RETURN VALUES

This function returns Linux error codes such as _EACCES_ or _ENOENT_.

# SEE ALSO

_libhwpwm.h(3)_

# AUTHORS

The _libhwpwm_ library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
