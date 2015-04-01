#include <stdio.h>
#include "str2double.h"

int main()  {
	double f = str2double("-12123.123");
	printf("%f\n", f);
	return 0;
}