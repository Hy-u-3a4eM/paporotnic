#include <array>
#include <cstddef>
#include <print>
#include <iostream>

auto main() -> int {
    int value{10};
    int* pointer{&value};

    std::println("Адрес переменной: {}", static_cast<const void*>(pointer));
    std::println("Значение по этому адресу: {}", *pointer);
    std::println("Адрес самого указателя: {}", static_cast<const void*>(&pointer));

    *pointer = 25;
    std::println("Переменная после изменения: {}", value);

    std::array numbers{2, 4, 6, 8, 10};

    int* array_pointer{numbers.data()};

    std::print("Элементы массива: ");
    for (std::size_t i{}; i < numbers.size(); ++i) {
        std::print("{}{}", i == 0 ? "" : " ", *(array_pointer + i));
    }
    std::println("");

    int number{5};
    int *const fixed_pointer{&number};

    std::println("До изменения: {}", number);
    *fixed_pointer = 42;
    std::println("После изменения: {}", number);

    //int another{99};
    //fixed_pointer = &another;

    return 0;
}