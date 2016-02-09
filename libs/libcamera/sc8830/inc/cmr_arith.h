/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef _CMR_ARITH_H_
#define _CMR_ARITH_H_

#ifdef __cplusplus
extern "C"
{
#endif

#define FACE_DETECT_GAP_MAX    15
#define FACE_DETECT_GAP_MIN    1

int arithmetic_fd_init(const struct img_size * fd_size, uint32_t is_support_fd);
int arithmetic_fd_deinit(uint32_t is_support_fd);
int arithmetic_fd_start(void *data_addr);
void arithmetic_set_mem(uint32_t phy_addr, uint32_t vir_addr, uint32_t mem_size);
int arithmetic_hdr_init(uint32_t pic_width, uint32_t pic_height);
int arithmetic_hdr_deinit(void);
int arithmetic_hdr(struct img_addr *dst_addr,uint32_t width,uint32_t height);
void arithmetic_hdr_data(struct img_addr *addr,uint32_t y_size,uint32_t uv_size,uint32_t cap_cnt);
int arithmetic_mem_handle(uint32_t mem_size);
inline uint32_t arithmetic_fd_is_init(void);
inline uint32_t arithmetic_get_fd_num(void);
inline uint32_t arithmetic_fd_is_eb(void);
inline void arithmetic_set_fd_eb(uint32_t param);

#ifdef __cplusplus
}
#endif

#endif //for _CMR_ARITH_H_
