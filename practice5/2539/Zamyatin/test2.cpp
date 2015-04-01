#include <cmath>
#include <iostream>
#include <assert.h>
#include <algorithm>
#include <vector>
#include "practice.h"

bool eq(double a, double b)
{
    using namespace std;
    return abs(a-b) < max(0.00001, max(abs(b) * 0.00001, abs(a) * 0.00001));
}

using namespace std;
    
int main()
{
    char buffer[1024];
    double2str(1.0, buffer);
    vector<double> values {1.0, -1.0, 100000.0, -100000.0, 12345.0, 0.0, -0.0};

    for (double x: values)
    {
        double2str(x, buffer);
        cout << buffer << endl;
    }

    return 0;
}
