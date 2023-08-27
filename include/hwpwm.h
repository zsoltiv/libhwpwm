/*
 * Copyright (C) 2023 Zsolt Vadasz
 *
 * This file is part of libhwpwm.
 *
 * libhwpwm is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * libhwpwm is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with libhwpwm. If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef HWPWM_H
#define HWPWM_H

#include <stdint.h>
#include <stdbool.h>

struct hwpwm_chip;
struct hwpwm_chip *hwpwm_chip_open_index(unsigned i, int *error);
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
void hwpwm_channel_set_duty_cycle_percent(struct hwpwm_channel *channel,
                                          unsigned duty_cycle_percent);
void hwpwm_channel_set_polarity(struct hwpwm_channel *channel,
                                enum hwpwm_polarity polarity);
void hwpwm_channel_set_enable(struct hwpwm_channel *channel, bool enable);

#endif /* HWPWM_H */
