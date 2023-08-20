hwpwm_channel_set_polarity(3)

# NAME

hwpwm\_channel\_get\_period,
hwpwm\_channel\_get\_duty\_cycle,
hwpwm\_channel\_get\_polarity,
hwpwm\_channel\_get\_enable,
hwpwm\_channel\_set\_period,
hwpwm\_channel\_set\_duty\_cycle,
hwpwm\_channel\_set\_polarity,
hwpwm\_channel\_set\_enable - functions for setting PWM channel parameters

# SYNOPSIS

```
#include <hwpwm.h>

uint64_t hwpwm_channel_get_period(struct hwpwm_channel *channel);
uint64_t hwpwm_channel_get_duty_cycle(struct hwpwm_channel *channel);
enum hwpwm_polarity hwpwm_channel_get_polarity(struct hwpwm_channel *channel);
bool hwpwm_channel_get_enable(struct hwpwm_channel *channel);
void hwpwm_channel_set_period(struct hwpwm_channel *channel, uint64_t period);
void hwpwm_channel_set_duty_cycle(struct hwpwm_channel *channel,
                                  uint64_t duty_cycle);
enum hwpwm_polarity {
    HWPWM_POLARITY_NORMAL = 0,
    HWPWM_POLARITY_INVERSED,
};
void hwpwm_channel_set_polarity(struct hwpwm_channel *channel,
                                enum hwpwm_polarity polarity);
void hwpwm_channel_set_enable(struct hwpwm_channel *channel, bool enable);
```

# DESCRIPTION

The *hwpwm\_channel\_get\_\** and *hwpwm\_channel\_set\_\** functions each
get/set a property of the PWM _channel_.

# RETURN VALUES

*hwpwm\_channel\_get\_period* returns the PWM signal's period in _nanoseconds_.

*hwpwm\_channel\_get\_duty\_cycle* returns the PWM signal's duty cycle in
_nanoseconds_.

*hwpwm\_channel\_get\_polarity* returns either *HWPWM_POLARITY_NORMAL* if the
signal's polarity is normal, or *HWPWM_POLARITY_INVERSED*.

*hwpwm\_channel\_get\_enable* returns whether the PWM channel is enabled.

These parameters can be changed using the *hwpwm\_channel\_set_\** functions.

# SEE ALSO

*libhwpwm.h(3)*

# AUTHORS

The *libhwpwm* library was written by Zsolt Vadasz <zsolt_vadasz@protonmail.com>.
