#ifndef HWPWM_H
#define HWPWM_H

#include <stdint.h>
#include <stdbool.h>

struct hwpwm_chip;
struct hwpwm_chip *hwpwm_chip_open_index(unsigned i);
unsigned hwpwm_chip_get_channel_count(struct hwpwm_chip *chip);
int hwpwm_chip_get_error(struct hwpwm_chip *chip);
void hwpwm_chip_close(struct hwpwm_chip *chip);

enum hwpwm_polarity {
    HWPWM_POLARITY_NORMAL = 0,
    HWPWM_POLARITY_INVERSED,
};

struct hwpwm_channel;
struct hwpwm_channel *hwpwm_chip_export_channel(struct hwpwm_chip *chip,
                                                unsigned i);
void hwpwm_chip_unexport_channel(struct hwpwm_chip *chip,
                                 struct hwpwm_channel *channel);
uint64_t hwpwm_channel_get_period(struct hwpwm_channel *channel);
uint64_t hwpwm_channel_get_duty_cycle(struct hwpwm_channel *channel);
enum hwpwm_polarity hwpwm_channel_get_polarity(struct hwpwm_channel *channel);
bool hwpwm_channel_get_enable(struct hwpwm_channel *channel);
void hwpwm_channel_set_period(struct hwpwm_channel *channel, uint64_t period);
void hwpwm_channel_set_duty_cycle(struct hwpwm_channel *channel,
                                  uint64_t duty_cycle);
void hwpwm_channel_set_polarity(struct hwpwm_channel *channel,
                                enum hwpwm_polarity polarity);
void hwpwm_channel_set_enable(struct hwpwm_channel *channel, bool enable);

#endif /* HWPWM_H */
