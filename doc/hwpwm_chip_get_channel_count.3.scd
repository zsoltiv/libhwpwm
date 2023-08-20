hwpwm_chip_get_channel_count(3)

# NAME

hwpwm_chip_get_channel_count - Get the number of channels of a PWM chip

# SYNOPSIS

```
#include <hwpwm.h>

unsigned hwpwm\_chip\_get\_channel\_count(struct hwpwm\_chip \*chip);
```

# DESCRIPTION

Returns the number of channels of the PWM chip.

# RETURN VALUES

The number of channels the chip has.

# SEE ALSO

*libhwpwm.h(3)*

# AUTHORS

The *libhwpwm* library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
