import std;

static auto sum_array(const int* begin, const int* end) -> long long {
    long long sum{};

    for (const int* current{begin}; current != end; ++current) {
        sum += *current;
    }

    return sum;
}

static auto add(const int a, const int b) -> int {
    return a + b;
}

static auto subtract(const int a, const int b) -> int {
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
    constexpr std::array numbers{1, 2, 3, 4, 5};

    const auto total = sum_array(
        numbers.data(),
        numbers.data() + numbers.size()
    );

    std::println("Сумма массива: {}", total);

    Operation operation{select_operation('+')};

    if (operation != nullptr) {
        std::println("10 + 3 = {}", operation(10, 3));
    }

    operation = select_operation('-');

    if (operation != nullptr) {
        std::println("10 - 3 = {}", operation(10, 3));
    }

    float* dynamic_value{new float{20.84f}};

    std::println("Адрес: {}", static_cast<const void*>(dynamic_value));
    std::println("Значение: {:.2f}", *dynamic_value);

    delete dynamic_value;
    dynamic_value = nullptr;

    return 0;
}