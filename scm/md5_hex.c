#include <openssl/md5.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <libguile.h>

#define ISHEX(x) x >= 48 && x <= 57 && x >= 97 && x <= 122
#define LOWER_NIBBLE(x) x & 0x0f
#define UPPER_NIBBLE(x) x >> 4
char to_hex(int i) {
  assert(0 <= i && i <= 15);
  if (i <= 9) {
    return i + 48;
  } else {
    return i + 87;
  }
}

// output must have the length 2* MD5_DIGEST_LENGTH
void md5_hex (const char* input, char* output) {
  unsigned char bin_out[MD5_DIGEST_LENGTH];
  MD5((const unsigned char*) input, strlen(input), bin_out);
  for (int i = 0; i < MD5_DIGEST_LENGTH; i++) {
    output[2*i] = to_hex(UPPER_NIBBLE(bin_out[i]));
    output[2*i+1] = to_hex(LOWER_NIBBLE(bin_out[i]));
  }
  output[2*MD5_DIGEST_LENGTH] = 0;
}

SCM md5_hex_wrapper (SCM in) {
  char* c_in = scm_to_stringn(in, NULL, NULL, SCM_FAILED_CONVERSION_ERROR);
  char c_out[2*MD5_DIGEST_LENGTH];
  md5_hex(c_in, c_out);
  return scm_from_stringn(c_out, 2*MD5_DIGEST_LENGTH,
			  "UTF-8", SCM_FAILED_CONVERSION_ERROR);
}

void init_md5_hex () {
  scm_c_define_gsubr("md5_hex", 1, 0, 0, md5_hex_wrapper);
}

int main(int argc, char** argv) {
  assert(argc == 2);
  char h[2*MD5_DIGEST_LENGTH+1];
  md5_hex(argv[1], h);
  printf("%s\n", h);
  return 0;
}


/* Local Variables: */
/* flycheck-clang-include-path: ("/usr/include/guile/2.2/") */
/* compile-command: "gcc -I/usr/include/guile/2.2/ -shared -o libmd5_hex.so -lcrypto -lssl -fPIC md5_hex.c" */
/* End: */
