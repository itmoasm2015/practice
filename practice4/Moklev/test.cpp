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
    vector<char> data( 10000000, 'c');
    vector<char> data2(10000000, 'c');
    data.back() = 0;
    data[10000000 - 10] = 'd';
    data2.back() = 0;

    long long result = f(data.data() , data2.data());
    assert(result > 0);
    data[10000000 - 10] = 'a';
    result = f(data.data(), data2.data());
    assert(result < 0);
    data[10000000 - 10] = 'c';
    result = f(data.data(), data2.data());
    assert(result == 0);
    
    int count = 1000;
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
    assert(pr_strcmp("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", 
                     "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab") < 0);
    assert(pr_strcmp("123123123123123123123123123123123123123123123", 
                     "123123123123123123123123123123123123123123123") == 0);
    assert(pr_strcmp("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", 
                     "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") > 0);
    assert(pr_strcmp("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", 
                     "aaaaaaaaaaaaaaaaaaaaaaaaaaaaab") < 0);
    
    double scmp = benchmark(std::strcmp);
    cout << "strcmp   \t" << scmp << ",\t compare to std::strcmp: " << 100 << "%" << endl;
    double pcmp = benchmark(pr_strcmp);
    cout << "pr_strcmp\t" << pcmp << ",\t compare to std::strcmp: " << (int) ((100 * pcmp) / scmp) << "%" << endl;
    double ccmp = benchmark(c_strcmp);
    cout << "c_strcmp \t" << ccmp << ",\t compare to std::strcmp: " << (int) ((100 * ccmp) / scmp) << "%" << endl;
    return 0;
}
