/*
 * SYBAU!
 *
 * Copyright (C) 2026 Vedraj Gawas <gawasvedraj@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#ifndef _MISC_SYBAU_H
#define _MISC_SYBAU_H
#undef pr_info
#undef pr_warn
#undef pr_err
#undef pr_debug
#define pr_info(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define pr_warn(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define pr_err(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define pr_debug(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#undef sc_info
#undef sc_err
#undef sc_debug
#define sc_info(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define sc_err(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define sc_debug(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#undef dev_info
#undef dev_warn
#undef dev_err
#undef dev_dbg
#define dev_info(dev, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define dev_warn(dev, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define dev_err(dev, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define dev_dbg(dev, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#undef ln_info
#undef ln_err
#undef ln_dbg
#define ln_info(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define ln_err(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#define ln_dbg(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
#endif // _MISC_SYBAU_H
