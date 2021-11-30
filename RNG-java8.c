/**
RNG especificado em Java 8 portado para C.
https://docs.oracle.com/javase/8/docs/api/java/util/Random.html
* O long em Java tem 64 bits (https://www.w3schools.com/java/java_data_types.asp)
* O tipo de dados inteiro 64 bits em C é long long (https://gcc.gnu.org/onlinedocs/gcc/Long-Long.html)
*/

#include <stdio.h>
#include <stdlib.h>

long long seed;

void setSeed (long long newSeed) {
  seed=(newSeed ^ 0x5DEECE66DLL) & ((1LL << 48) - 1);
//  seed=newSeed;
}

/**
Generates the next pseudorandom number. Subclasses should override this, as this is used by all other methods.

The general contract of next is that it returns an int value and if the argument bits is between 1 and 32 (inclusive), then that many low-order bits of the returned value will be (approximately) independently chosen bit values, each of which is (approximately) equally likely to be 0 or 1. The method next is implemented by class Random by atomically updating the seed to

 (seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1)

and returning

 (int)(seed >>> (48 - bits)).
*/

int next(int bits) {
 seed=(seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
 return (int)(seed >> (48 - bits));
}

void main (void) {
	setSeed(0);
	for (int i=0;i<20;i++) {
		printf ("%d\n", next(31));
	}
	setSeed(0xFFFFFFFFFFFFFFFFLL);
	for (int i=0;i<20;i++) {
		printf ("%d\n", next(31));
	}
	setSeed(0xA0A0A0A0A0A0A0A0LL);
	for (int i=0;i<20;i++) {
		printf ("%d\n", next(31));
	}
}