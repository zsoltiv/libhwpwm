hwpwm_chip_get_error(3)

# NAME

*hwpwm\_chip\_get\_error* - Get the last error set by a *hwpwm\_chip\_\** function

# SYNOPSIS

```
#include <hwpwm.h>

int hwpwm\_chip\_get\_error(struct hwpwm\_chip \*chip);
```

# DESCRIPTION

This function returns the error value from a PWM chip object (set by
*hwpwm\_chip\_\** family of functions).

# RETURN VALUES

This function returns Linux error codes such as *EACCES* or *ENOENT*.

# SEE ALSO

*libhwpwm.h(3)*

# AUTHORS

The *libhwpwm* library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
