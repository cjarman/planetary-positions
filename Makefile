# $Header$
# this Makefile creates a SwissEph library and a swetest sample on 64-bit
# Redhat Enterprise Linux RHEL 6.

# The mode marked as 'Linux' should also work with the GNU C compiler
# gcc on other systems. 

# If you modify this makefile for another compiler, please
# let us know. We would like to add as many variations as possible.
# If you get warnings and error messages from your compiler, please
# let us know. We like to fix the source code so that it compiles
# free of warnings.
# send email to the Swiss Ephemeris mailing list.
#

CFLAGS = -g -Wall -fPIC  	# for Linux and other gcc systems
OP=$(CFLAGS)  
CC=cc	#for Linux

# compilation rule for general cases
.o :
	$(CC) $(OP) -o $@ $? -lm
.c.o:
	$(CC) -c $(OP) $<     

SWEOBJ = swedate.o swehouse.o swejpl.o swemmoon.o swemplan.o swepcalc.o sweph.o\
	swepdate.o swephlib.o swecl.o swehel.o

swetest: swetest.o libswe.a
	$(CC) $(OP) -o swetest swetest.o -L. -lswe -lm -ldl

swemini: swemini.o libswe.a
	$(CC) $(OP) -o swemini swemini.o -L. -lswe -lm







# create an archive and a dynamic link libary fro SwissEph
# a user of this library will inlcude swephexp.h  and link with -lswe

libswe.a: $(SWEOBJ)
	ar r libswe.a	$(SWEOBJ)

libswe.so: $(SWEOBJ)
	$(CC) -shared -o libswe.so $(SWEOBJ)

clean:
	rm -f *.o swetest libswe*




out/linux/x64:
	mkdir -p out/linux/x64

out/linux/x64/native_functions.o: native_functions.c | out/linux/x64
	$(CC) $(CFLAGS) -c -o $@ native_functions.c

out/linux/x64/libnative_functions.so: out/linux/x64/native_functions.o
	$(CC) $(CFLAGS) -s -shared -o $@ out/linux/x64/native_functions.o

out/linux/ia32:
	mkdir -p out/linux/ia32

out/linux/ia32/native_functions.o: native_functions.c | out/linux/ia32
	$(CC) $(CFLAGS) -m32 -c -o $@ native_functions.c

out/linux/ia32/libnative_functions.so: out/linux/ia32/native_functions.o
	$(CC) $(CFLAGS) -m32 -s -shared -o $@ out/linux/ia32/native_functions.o

out/linux/arm64:
	mkdir -p out/linux/arm64

out/linux/arm64/native_functions.o: native_functions.c | out/linux/arm64
	$(CCARM64) $(CFLAGS) -c -o $@ native_functions.c

out/linux/arm64/libnative_functions.so: out/linux/arm64/native_functions.o
	$(CCARM64) $(CFLAGS) -s -shared -o $@ out/linux/arm64/native_functions.o

out/linux/arm:
	mkdir -p out/linux/arm

out/linux/arm/native_functions.o: native_functions.c | out/linux/arm
	$(CCARM) $(CFLAGS) -c -o $@ native_functions.c

out/linux/arm/libnative_functions.so: out/linux/arm/native_functions.o
	$(CCARM) $(CFLAGS) -s -shared -o $@ out/linux/arm/native_functions.o

	
###
swecl.o: swejpl.h sweodef.h swephexp.h swedll.h sweph.h swephlib.h
sweclips.o: sweodef.h swephexp.h swedll.h
swedate.o: swephexp.h sweodef.h swedll.h
swehel.o: swephexp.h sweodef.h swedll.h
swehouse.o: swephexp.h sweodef.h swedll.h swephlib.h swehouse.h
swejpl.o: swephexp.h sweodef.h swedll.h sweph.h swejpl.h
swemini.o: swephexp.h sweodef.h swedll.h
swemmoon.o: swephexp.h sweodef.h swedll.h sweph.h swephlib.h
swemplan.o: swephexp.h sweodef.h swedll.h sweph.h swephlib.h swemptab.h
swepcalc.o: swepcalc.h swephexp.h sweodef.h swedll.h
sweph.o: swejpl.h sweodef.h swephexp.h swedll.h sweph.h swephlib.h
swephlib.o: swephexp.h sweodef.h swedll.h sweph.h swephlib.h
swetest.o: swephexp.h sweodef.h swedll.h




