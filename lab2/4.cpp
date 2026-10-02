#include "previous_sum.h"
import std;

#define SUM(a, b) ((a) + (b))

auto main() -> int {
    demo::print_sum(5);
    demo::print_sum(10);
    demo::print_sum(-3);
    demo::print_sum(7);

    std::println("SUM(2 + 3, 4) * 2 = {}", SUM(2 + 3, 4) * 2);

    return 0;
}