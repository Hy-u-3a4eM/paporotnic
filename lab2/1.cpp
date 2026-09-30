#include <iostream>
#include <numeric>
#include <print>

auto main() -> int {
    double a{}, b{};

    std::print("Введите два числа: ");
    if (!(std::cin >> a >> b)) {
        std::println("Ошибка: нужно ввести два числа.");
        return 1;
    }

    const auto average = std::midpoint(a, b);
    std::println("Среднее арифметическое: {}", average);

    char operation{};
    std::print("Введите операцию (+, -, *, /): ");
    std::cin >> operation;

    switch (operation) {
    case '+':
        std::println("Результат: {}", a + b);
        break;

    case '-':
        std::println("Результат: {}", a - b);
        break;

    case '*':
        std::println("Результат: {}", a * b);
        break;

    case '/':
        if (b == 0.0) {
            std::println("Ошибка: деление на ноль!");
        } else {
            std::println("Результат: {}", a / b);
        }
        break;

    default:
        std::println("Неизвестная операция!");
        break;
    }

    return 0;
}