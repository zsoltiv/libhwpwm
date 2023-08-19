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
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with libhwpwm. If not, see <https://www.gnu.org/licenses/>. 
*/

#define _XOPEN_SOURCE 700
#include <inttypes.h>
#include <stdbool.h>
#include <errno.h>
#include <unistd.h>
#include <limits.h>
#include <fcntl.h>
#include <stdio.h>
#include <tgmath.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>

#include "hwpwm.h"

#define HWPWM_SYSFS_PWMCHIPN "/sys/class/pwm/pwmchip"

struct hwpwm_channel {
    unsigned idx;
    int duty_cycle, enable, period, polarity, lasterror;
};

struct hwpwm_chip {
    char *path;
    int export, unexport, npwm, lasterror;
};

static inline size_t hwpwm_digits(uint64_t n)
{
    return n == 0 ? 1 : log10(n) + 1;
}

static char *hwpwm_idx_to_str(unsigned n)
{
    size_t bufsize = hwpwm_digits(n) + 1;
    char *buf = calloc(bufsize, 1);
    if(!buf)
        return NULL;
    snprintf(buf, bufsize, "%u", n);
    return buf;
}

static int hwpwm_open_in_dir(const char *dir, const char *file, int flags)
{
    size_t fullpathlen = strlen(dir) + strlen(file) + 2;
    char *fullpath = calloc(fullpathlen, 1);
    if(!fullpath)
        return ENOMEM;
    snprintf(fullpath, fullpathlen, "%s/%s", dir, file);
    int fd = open(fullpath, flags);
    return fd;
}

static struct hwpwm_chip *hwpwm_chip_open_path(const char *path)
{
    if(!path)
        return NULL;

    struct hwpwm_chip *chip = malloc(sizeof(struct hwpwm_chip));
    if(!chip)
        return NULL;
    size_t pathlen = strlen(path);
    chip->path = calloc(pathlen + 1, 1);
    if(!chip->path) {
        chip->lasterror = errno; // ENOMEM
        return chip;
    }
    strncpy(chip->path, path, pathlen);

    chip->export = hwpwm_open_in_dir(path, "export", O_WRONLY);
    if(chip->export < 0) {
        chip->lasterror = errno;
        goto export_fail;
    }
    chip->unexport = hwpwm_open_in_dir(path, "unexport", O_WRONLY);
    if(chip->unexport < 0) {
        chip->lasterror = errno;
        goto unexport_fail;
    }
    chip->npwm = hwpwm_open_in_dir(path, "npwm", O_RDONLY);
    if(chip->npwm < 0) {
        chip->lasterror = errno;
        goto npwm_fail;
    }

    chip->lasterror = 0;
    return chip;

npwm_fail:
    close(chip->unexport);
unexport_fail:
    close(chip->export);
export_fail:
    free(chip->path);
    return chip;
}

struct hwpwm_chip *hwpwm_chip_open_index(unsigned i)
{
    size_t pathlen = strlen(HWPWM_SYSFS_PWMCHIPN) + hwpwm_digits(i) + 1;
    char *path = calloc(pathlen, 1);
    if(!path)
        return NULL;
    snprintf(path, pathlen, HWPWM_SYSFS_PWMCHIPN "%u", i);

    struct hwpwm_chip *chip = hwpwm_chip_open_path(path);
    free(path);

    return chip;
}

void hwpwm_chip_close(struct hwpwm_chip *chip)
{
    if(!chip) return;
    close(chip->export);
    close(chip->unexport);
    close(chip->npwm);
    free(chip->path);
}

int hwpwm_chip_get_error(struct hwpwm_chip *chip)
{
    return chip ? chip->lasterror : ENOMEM;
}

struct hwpwm_channel *hwpwm_chip_export_channel(struct hwpwm_chip *chip,
                                                unsigned i)
{
    if(!chip) return NULL;
    char *istr = hwpwm_idx_to_str(i);
    if(!istr) return NULL;
    size_t istrlen = strlen(istr);
    if(write(chip->export, istr, istrlen) < 0 && errno != EBUSY) {
        chip->lasterror = errno;
        free(istr);
        return NULL;
    }

    struct hwpwm_channel *channel = malloc(sizeof(struct hwpwm_channel));
    if(!channel) {
        chip->lasterror = errno;
        free(istr);
        return NULL;
    }

    channel->idx = i;

    size_t channelbaselen = strlen(chip->path) + istrlen + 5;
    char *channelbase = calloc(channelbaselen, 1);
    if(!channelbase) {
        chip->lasterror = errno;
        free(istr);
        goto channelbaselen_fail;
    }
    snprintf(channelbase, channelbaselen, "%s/pwm%s", chip->path, istr);
    free(istr);

    channel->duty_cycle = hwpwm_open_in_dir(channelbase, "duty_cycle", O_RDWR);
    if(channel->duty_cycle < 0) {
        chip->lasterror = errno;
        goto channelbaselen_fail;
    }
    channel->period = hwpwm_open_in_dir(channelbase, "period", O_RDWR);
    if(channel->period < 0) {
        chip->lasterror = errno;
        goto period_fail;
    }
    channel->polarity = hwpwm_open_in_dir(channelbase, "polarity", O_RDWR);
    if(channel->polarity < 0) {
        chip->lasterror = errno;
        goto polarity_fail;
    }
    channel->enable = hwpwm_open_in_dir(channelbase, "enable", O_RDWR);
    if(channel->enable < 0) {
        chip->lasterror = errno;
        goto enable_fail;
    }
    free(channelbase);
    chip->lasterror = 0;
    return channel;

enable_fail:
    close(channel->polarity);
polarity_fail:
    close(channel->period);
period_fail:
    close(channel->duty_cycle);
channelbaselen_fail:
    free(channel);
    free(channelbase);
    return NULL;
}
void hwpwm_chip_unexport_channel(struct hwpwm_chip *chip,
                                 struct hwpwm_channel *channel)
{
    if(!chip || !channel) return;

    close(channel->duty_cycle);
    close(channel->enable);
    close(channel->period);
    close(channel->polarity);

    char *idxstr = hwpwm_idx_to_str(channel->idx);
    if(!idxstr) {
        chip->lasterror = errno;
        free(channel);
        return;
    }

    if(write(chip->unexport, idxstr, strlen(idxstr) < 0) && errno != EBUSY)
        chip->lasterror = errno;

    free(channel);
    chip->lasterror = 0;
}


unsigned hwpwm_chip_get_channel_count(struct hwpwm_chip *chip)
{
    if(!chip) return 0;

    size_t digits = hwpwm_digits(UINT_MAX);
    char *buf = calloc(digits + 1, 1);
    pread(chip->npwm, buf, digits, 0);
    unsigned ret =  (unsigned)strtoul(buf, NULL, 10);
    free(buf);
    return ret;
}

#define HWPWM_CHANNEL_GETTER(prop, type)                         \
    type hwpwm_channel_get_##prop(struct hwpwm_channel *channel) \
    {                                                            \
        if(!channel) return 0;                                   \
        size_t bufsize = hwpwm_digits(UINT64_MAX) + 1;           \
        char *buf = calloc(bufsize, 1);                          \
        pread(channel->prop, buf, bufsize - 1, 0);               \
        uint64_t ret;                                            \
        sscanf(buf, "%"SCNu64, &ret);                            \
        free(buf);                                               \
        return (type)ret;                                        \
    }

#define HWPWM_CHANNEL_SETTER(prop, type)                                    \
    void hwpwm_channel_set_##prop(struct hwpwm_channel *channel, type prop) \
    {                                                                       \
        if(!channel) return;                                                \
        size_t bufsize = hwpwm_digits(prop) + 1;                            \
        char *buf = calloc(bufsize + 1, 1);                                 \
        if(!buf) return;                                                    \
        snprintf(buf, bufsize, "%"PRIu64, (uint64_t)prop);                  \
        write(channel->prop, buf, bufsize - 1);                             \
        free(buf);                                                          \
    }

HWPWM_CHANNEL_GETTER(period, uint64_t)
HWPWM_CHANNEL_GETTER(duty_cycle, uint64_t)
HWPWM_CHANNEL_GETTER(enable, bool)
HWPWM_CHANNEL_SETTER(period, uint64_t)
HWPWM_CHANNEL_SETTER(duty_cycle, uint64_t)
HWPWM_CHANNEL_SETTER(enable, bool)

enum hwpwm_polarity hwpwm_channel_get_polarity(struct hwpwm_channel *channel)
{
    if(!channel) return HWPWM_POLARITY_NORMAL;
    static const size_t bufsize = 9; // strlen("inversed") + 1
    char buf[bufsize];
    pread(channel->polarity, buf, bufsize, 0);
    return *buf == 'n' ? HWPWM_POLARITY_NORMAL : HWPWM_POLARITY_INVERSED;
}

void hwpwm_channel_set_polarity(struct hwpwm_channel *channel,
                                enum hwpwm_polarity polarity)
{
    if(!channel) return;
    static const char *const normal = "normal";
    static const char *const inversed = "inversed";
    if(polarity == HWPWM_POLARITY_NORMAL)
        write(channel->polarity, normal, strlen(normal));
    else
        write(channel->polarity, inversed, strlen(inversed));
}
