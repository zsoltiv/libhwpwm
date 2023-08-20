hwpwm_chip_close(3)

# NAME

hwpwm\_chip\_close - Close PWM chip object

# SYNOPSIS

```
#include <hwpwm.h>

void hwpwm\_chip\_close(struct hwpwm\_chip \*chip);
```

# DESCRIPTION

Closes the PWM chip object. If _chip_ is *NULL*, it does nothing.

# RETURN VALUES

This function doesn't return anything.

# SEE ALSO

*libhwpwm.h(3)*

# AUTHORS

The *libhwpwm* library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
