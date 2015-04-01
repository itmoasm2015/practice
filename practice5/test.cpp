#include <cmath>
#include <iostream>
#include <assert.h>
#include <algorithm>
#include "practice.h"

bool eq(double a, double b)git 
{
    using namespace std;
    return abs(a-b) < max(0.00001, abs(a) * 0.00001);
}

int main()
{
    double x = 0.4;
    x = str2double("-.1234");
    printf("x : %f\n", x);

    assert(eq(str2double("0.0"), 0.0));
    assert(eq(str2double("1.0"), 1.0));
    assert(eq(str2double("1000000.0"), 1000000.0));
    assert(eq(str2double("0.5"), 0.5));
    assert(eq(str2double("0.33333"), 0.33333));
    assert(eq(str2double("-.1234"), -0.1234));

    return 0;
}
