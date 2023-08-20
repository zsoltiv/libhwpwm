hwpwm_chip_open_index(3)

# NAME

hwpwm\_chip\_open\_index - Open PWM chip object at index

# SYNOPSIS

```
#include <hwpwm.h>

struct hwpwm\_chip \*_hwpwm\_chip\_open\_index(unsigned i, int \*error);
```

# DESCRIPTION

Opens the *export*, *unexport*, *npwm* files for the  PWM chip at
/sys/class/pwm/pwmchip_i_.

The *i* parameter is the index of the PWM chip.

If the function fails and _error_ is not *NULL*, the integer it's pointing to
is set to the last error code.

# RETURN VALUES

This function returns a pointer to an opaque _struct hwpwm\_chip_ or *NULL* if
it failed.

# SEE ALSO

*libhwpwm.h(3)*

# AUTHORS

The *libhwpwm* library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
