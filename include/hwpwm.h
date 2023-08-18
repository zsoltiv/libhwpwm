#ifndef HWPWM_H
#define HWPWM_H

struct hwpwm_chip;
struct hwpwm_chip *hwpwm_chip_open_path(const char *name);
struct hwpwm_chip *hwpwm_chip_open_index(unsigned i);
void hwpwm_chip_close(struct hwpwm_chip *chip);


#endif /* HWPWM_H */
