#include "stdio.h"
#include "assert.h"
#include "math.h"
#include "str2double.h"

#define eps 1e-8

#define test(ch, result) \
	assert(fabs(str2double(ch) - result) < eps);

int main() {
	test("1.0", 1.0d);
	test("13847.0", 13847.0d);
	test("0.25", 0.25d);
	test("0.000001", 0.000001d);
	test("1.01", 1.01d);
	test("-10.0", -10.0d);
	test("-1034985.023487", -1034985.023487);
	test("31415.", 31415.d);
	test(".1", .1d);
	test("-.1", -.1d);
	test("-123.123", -123.123d);
	test("0.0", .0d);
	test("-.0", .0d);
}
