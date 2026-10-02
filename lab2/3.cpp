#include <array>
#include <cstddef>
#include <print>

static auto sum_to(const int number = 1) -> long long {
    if (number <= 0) {
        return 0;
    }

    long long sum{};

    for (long long i{1}; i <= number; ++i) {
        sum += i;
    }

    return sum;
}

static auto calculate(const int a, const int b, int &sum, int &product) -> void {
    sum = a + b;
    product = a * b;
}

auto main() -> int {
    constexpr std::array matrix{
        std::array{1, 2, 3},
        std::array{4, 5, 6}
    };

    int total{};

    for (const auto &row : matrix) {
        for (const int element : row) {
            total += element;
        }
    }

    std::println("Сумма всех элементов: {}", total);

    std::array<int, 3> column_sums{};

    for (const auto &row : matrix) {
        for (std::size_t column{}; column < row.size(); ++column) {
            column_sums[column] += row[column];
        }
    }

    std::print("Суммы столбцов: ");

    for (std::size_t i{}; i < column_sums.size(); ++i) {
        std::print("{}{}", i == 0 ? "" : " ", column_sums[i]);
    }

    std::println("");

    float value{20.84f};
    float &first_ref = value;
    float &second_ref = value;

    std::println("До изменения: {:.2f}", value);

    first_ref = 35.5f;

    std::println("Переменная: {:.2f}", value);
    std::println("Первая ссылка: {:.2f}", first_ref);
    std::println("Вторая ссылка: {:.2f}", second_ref);

    std::println("sum_to(-3) = {}", sum_to(-3)); // 0
    std::println("sum_to(0) = {}", sum_to(0));   // 0
    std::println("sum_to(4) = {}", sum_to(4));   // 10
    std::println("sum_to() = {}", sum_to());    // 1

    int sum{};
    int product{};

    std::println("До вызова: сумма = {}, произведение = {}", sum, product);

    calculate(4, 5, sum, product);

    std::println("После вызова: сумма = {}, произведение = {}", sum, product);

    int outside{42};
    std::println("Внешняя переменная до цикла: {}", outside);

    for (int i{}; i < 3; ++i) {
        std::println("Двумерный массив:");

        for (const auto &row : matrix) {
            std::println("{} {} {}", row[0], row[1], row[2]);
        }

        std::println("Внешняя переменная: {}", outside);

        int inside{7};
        std::println("Внутренняя переменная: {}", inside);
    }

    //std::println("За пределами цикла: {}", inside);

    return 0;
}