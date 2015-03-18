#include <iostream>
#include <ctime>
#include <cstdlib>
#include <cmath>
#include <cassert>
#include <cstring>
#include "strcmp.h"

namespace {
}


int main() {
    using namespace std;
    assert(pr_strcmp("hello", "hello") == 0);
    assert(pr_strcmp("hello", "hallo") > 0);
    assert(pr_strcmp("hello", "hell") > 0);
    assert(pr_strcmp("123", "23") < 0);
    assert(pr_strcmp("12", "123") < 0);
    return 0;
}
