import std;
#include "previous_sum.h"

namespace demo {

    auto print_sum(int number) -> void {
        using std::println;

        static int previous{0};

        println("{} + {} = {}", number, previous, number + previous);

        previous = number;
    }

}