#include "previous_sum.h"
#include <print>

namespace demo {

    auto print_sum(int number) -> void {
        using std::println;

        static int previous{0};

        println("{} + {} = {}", number, previous, number + previous);

        previous = number;
    }

}