hwpwm_chip_export_channel(3)

# NAME

hwpwm_chip_export_channel, hwpwm_chip_unexport_channel -
export and unexport PWM channels

# SYNOPSIS

```
\#include <hwpwm.h>

struct hwpwm_channel *hwpwm_chip_export_channel(struct hwpwm_chip *chip,
                                                unsigned i)\;
void hwpwm_chip_unexport_channel(struct hwpwm_chip *chip,
                                 struct hwpwm_channel *channel)\;
```

# DESCRIPTION

The functions *hwpwm\_chip\_export\_channel* and
*hwpwm\_chip\_unexport\_channel* export and unexport PWM channels of a
_struct hwpwm\_chip_.

In both functions, *chip* is a pointer to a valid _struct hwpwm\_chip_.

In *hwpwm\_chip\_export\_channel*, *i* is the index of the channel you
wish to export.

In *hwpwm\_chip\_unexport\_channel*, *channel* is a pointer previously
returned by *hwpwm\_chip\_export\_channel*.

# RETURN VALUES

*hwpwm\_chip\_export\_channel* returns a pointer to a _struct hwpwm\_channel_
or NULL on failure. In this case, you should call *hwpwm\_chip\_get\_error*
to access the error value.

*hwpwm\_chip\_unexport\_channel* doesn't return anything.

# SEE ALSO

*libhwpwm.h(3)*

# AUTHORS

The *libhwpwm* library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
