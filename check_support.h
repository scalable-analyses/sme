#ifndef CHECK_SUPPORT_H
#define CHECK_SUPPORT_H

void check_neon_bf16_support();
void check_sve_support();
void check_streaming_sve_support();
void check_sme_support();
int check_sve_streaming_length();

#endif
