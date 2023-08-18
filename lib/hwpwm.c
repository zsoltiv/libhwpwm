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

#include <stdbool.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <tgmath.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>

#define HWPWM_SYSFS_DIR "/sys/class/pwm"
#define HWPWM_SYSFS_PWMCHIPN HWPWM_SYSFS_DIR "/pwmchip"


struct hwpwm_channel {
    int duty_cycle, enable, period, polarity;
};

struct hwpwm_chip {
    int export, unexport, lasterror;
};

static inline size_t hwpwm_digits(unsigned n)
{
    return log10(n) + 1;
}

static int hwpwm_open_in_dir(const char *dir, const char *file, int flags)
{
    size_t fullpathlen = strlen(dir) + strlen(file) + 1;
    char *fullpath = calloc(fullpathlen + 1, 1);
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
    size_t namelen = strlen(path);

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
