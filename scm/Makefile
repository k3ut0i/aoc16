CFLAGS = -I/usr/include/guile/2.2/
LDLIBS = -lssl -lcrypto -lguile-2.2

md5_test: md5_hex.c
	$(CC) $(CFLAGS) $(LDLIBS) $^ -o $@
libmd5_hex.so: md5_hex.c
	$(CC) $(CFLAGS) $(LDLIBS) --shared -fPIC $^ -o $@
