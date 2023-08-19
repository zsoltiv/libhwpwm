#ifndef HWPWM_H
#define HWPWM_H

struct hwpwm_chip;
struct hwpwm_chip *hwpwm_chip_open_path(const char *name);
struct hwpwm_chip *hwpwm_chip_open_index(unsigned i);
unsigned hwpwm_chip_get_channel_count(struct hwpwm_chip *chip);
int hwpwm_chip_get_error(struct hwpwm_chip *chip);
void hwpwm_chip_close(struct hwpwm_chip *chip);

struct hwpwm_channel;
struct hwpwm_channel *hwpwm_chip_export_channel(struct hwpwm_chip *chip,
                                                unsigned i);
void hwpwm_chip_unexport_channel(struct hwpwm_chip *chip,
                                 struct hwpwm_channel *channel);

#endif /* HWPWM_H */
