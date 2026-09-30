#include <array>
#include <cstddef>
#include <iostream>
#include <print>

int main() {
    // 1. Ввод положительного целого числа.
    int number{};

    while (true) {
        std::print("Введите положительное целое число: ");

        if (!(std::cin >> number)) {
            std::println("Ошибка: нужно ввести целое число.");
            return 1;
        }

        if (number > 0) {
            break;
        }

        std::println("Число должно быть больше нуля. Попробуйте ещё раз.");
    }

    // 2. Сумма чисел от 1 до введённого числа включительно.
    long long sum{};

    for (long long i{1}; i <= number; ++i) {
        sum += i;
    }

    std::println("Сумма чисел от 1 до {}: {}", number, sum);

    // 3. Массив из 10 чисел. Размер определяется автоматически.
    constexpr std::array numbers{4, 7, 2, 9, 5, 8, 1, 6, 3, 10};

    // 4. Вывод всех элементов через пробел.
    std::print("Все элементы: ");

    for (std::size_t i{}; i < numbers.size(); ++i) {
        std::print("{}{}", i == 0 ? "" : " ", numbers[i]);
    }

    std::println("");

    // 5. Элементы на чётных позициях: 0, 2, 4, 6, 8.
    std::print("Элементы на чётных позициях: ");

    for (std::size_t i{}; i < numbers.size(); ++i) {
        if (i % 2 == 0) {
            std::print("{}{}", i == 0 ? "" : " ", numbers[i]);
        }
    }

    std::println("");

    // 6. Сумма элементов на нечётных позициях: 1, 3, 5, 7, 9.
    int odd_positions_sum{};

    for (std::size_t i{}; i < numbers.size(); ++i) {
        if (i % 2 != 0) {
            odd_positions_sum += numbers[i];
        }
    }

    std::println(
        "Сумма элементов на нечётных позициях: {}",
        odd_positions_sum
    );

    return 0;
}