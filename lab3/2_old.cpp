#include <iomanip>
#include <iostream>

static long long sum_array(const int* begin, const int* end) {
    long long sum = 0;

    for (const int *current = begin; current != end; ++current) {
        sum += *current;
    }

    return sum;
}

static int add(const int a, const int b) {
    return a + b;
}

static int subtract(const int a, const int b) {
    return a - b;
}

// Указатель на функцию, принимающую два int и возвращающую int.
using Operation = int (*)(int, int);

static Operation select_operation(const char sign) {
    switch (sign) {
    case '+':
        return &add;
    case '-':
        return &subtract;
    default:
        return nullptr;
    }
}

int main() {
    constexpr int numbers[] = {1, 2, 3, 4, 5};

    const auto total = sum_array(
        numbers,
        numbers + std::size(numbers)
    );

    std::cout << "Сумма массива: " << total << std::endl;

    Operation operation = select_operation('+');

    if (operation != nullptr) {
        std::cout << "10 + 3 = " << operation(10, 3) << std::endl;
    }

    operation = select_operation('-');

    if (operation != nullptr) {
        std::cout << "10 - 3 = " << operation(10, 3) << std::endl;
    }

    auto *dynamic_value = new float(20.84f);

    std::cout << "Адрес: " << dynamic_value << std::endl;
    std::cout << "Значение: " << std::fixed << std::setprecision(2) << *dynamic_value << std::endl;

    delete dynamic_value;
    dynamic_value = nullptr;

    return 0;
}