/*
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

#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <tgmath.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>

#include "hwpwm.h"

#define HWPWM_SYSFS_DIR "/sys/class/pwm"
#define HWPWM_SYSFS_PWMCHIPN HWPWM_SYSFS_DIR "/pwmchip"

struct hwpwm_channel {
    unsigned idx;
    int duty_cycle, enable, period, polarity, lasterror;
};

struct hwpwm_chip {
    char *path;
    int export, unexport, lasterror;
};

static inline size_t hwpwm_digits(unsigned n)
{
    return log10(n) + 1;
}

static char *hwpwm_idx_to_str(unsigned n)
{
    size_t digits = hwpwm_digits(n);
    char *buf = calloc(digits + 1, 1);
    if(!buf)
        return NULL;
    snprintf(buf, digits, "%u", n);
    return buf;
}

static int hwpwm_open_in_dir(const char *dir, const char *file, int flags)
{
    size_t fullpathlen = strlen(dir) + strlen(file) + 1;
    char *fullpath = calloc(fullpathlen + 1, 1);
    if(!fullpath)
        return ENOMEM;
    snprintf(fullpath, fullpathlen, "%s/%s", dir, file);
    int fd = open(fullpath, flags);
    return fd;
}

struct hwpwm_chip *hwpwm_chip_open_path(const char *path)
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
        return chip;
    }
    chip->unexport = hwpwm_open_in_dir(path, "unexport", O_WRONLY);
    if(chip->unexport < 0) {
        chip->lasterror = errno;
        return chip;
    }

    chip->lasterror = 0;
    return chip;
}

struct hwpwm_chip *hwpwm_chip_open_index(unsigned i)
{
    size_t pathlen = strlen(HWPWM_SYSFS_PWMCHIPN) + hwpwm_digits(i);
    char *path = calloc(pathlen + 1, 1);
    if(!path)
        return NULL;
    snprintf(path, pathlen, HWPWM_SYSFS_PWMCHIPN "%u", i);

    struct hwpwm_chip *chip = hwpwm_chip_open_path(path);
    free(path);

    return chip;
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
    if(write(chip->export, istr, istrlen) < 0) {
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

    size_t channelbaselen = strlen(chip->path) + istrlen + 3;
    char *channelbase = calloc(channelbaselen + 1, 1);
    if(!channelbase) {
        chip->lasterror = errno;
        free(channel);
        free(istr);
        return NULL;
    }
    snprintf(channelbase, channelbaselen, "%s/pwm%s", chip->path, istr);

    channel->duty_cycle = hwpwm_open_in_dir(channelbase, "duty_cycle", O_WRONLY);
    if(channel->duty_cycle < 0) {
        chip->lasterror = errno;
        free(channel);
        free(istr);
        return NULL;
    }
    channel->period = hwpwm_open_in_dir(channelbase, "period", O_WRONLY);
    if(channel->period < 0) {
        chip->lasterror = errno;
        free(channel);
        free(istr);
        close(channel->duty_cycle);
        return NULL;
    }
    channel->polarity = hwpwm_open_in_dir(channelbase, "polarity", O_WRONLY);
    if(channel->polarity < 0) {
        chip->lasterror = errno;
        free(channel);
        free(istr);
        close(channel->duty_cycle);
        close(channel->period);
        return NULL;
    }
    channel->enable = hwpwm_open_in_dir(channelbase, "enable", O_WRONLY);
    if(channel->enable < 0) {
        chip->lasterror = errno;
        free(channel);
        free(istr);
        close(channel->duty_cycle);
        close(channel->period);
        close(channel->polarity);
        return NULL;
    }

    free(istr);
    free(channelbase);
    chip->lasterror = 0;
    return channel;
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

    if(write(chip->unexport, idxstr, strlen(idxstr) < 0))
        chip->lasterror = errno;

    free(channel);
}
