#include <iostream>
#include <ctime>
#include <cstdlib>
#include <cmath>
#include <cassert>
#include <cstring>
#include <vector>
#include <sys/time.h>
#include "strcmp.h"

int c_strcmp(char const *s1, char const *s2) {
    while (*s1 && *s2 && *s1 == *s2) {
        ++s1;
        ++s2;
    }
    if (*s1 || *s2) {
        if (*s1 < *s2)
            return -1;
        else
            return 1;
    } else {
        return 0;
    }
}

double benchmark(decltype(std::strcmp) f) {
    using namespace std;
    vector<char> data(1000000, 'c');
    vector<char> data2(1000000, 'c');
    data.back() = 0;
    data2.back() = 0;

    int count = 10;
    double us = 0;
    for (int i = 0; i < count; ++i) {
        timeval tv1, tv2;
        gettimeofday(&tv1, 0);

        f(data.data(), data2.data());

        gettimeofday(&tv2, 0);
        us += (tv2.tv_sec - tv1.tv_sec) * 1e6;
        us += tv2.tv_usec - tv1.tv_usec;
    }
    return us / count;
}


int main() {
    using namespace std;
    assert(pr_strcmp("hello", "hello") == 0);
    assert(pr_strcmp("hello", "hallo") > 0);
    assert(pr_strcmp("hello", "hell") > 0);
    assert(pr_strcmp("123", "23") < 0);
    assert(pr_strcmp("12", "123") < 0);
    
    cout << "strcmp\t" << benchmark(std::strcmp) << endl;
    cout << "pr_strcmp\t" << benchmark(pr_strcmp) << endl;
    cout << "c_strcmp\t" << benchmark(c_strcmp) << endl;
    return 0;
}
