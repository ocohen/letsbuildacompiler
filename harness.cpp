#include <iostream>

extern "C" int run();

int main()
{
    int y = 1;
    int x = run();
    int z = y / x;
    std::cout << x << std::endl;
    return 0;
}
