#include <cstddef>
#include <print>
#include <iostream>

int main() {
    int value = 10;
    int *pointer = &value;

    std::cout << "Адрес переменной: " << pointer << std::endl;
    std::cout << "Значение по этому адресу: " << *pointer << std::endl;
    std::cout << "Адрес самого указателя: " << &pointer << std::endl;

    *pointer = 25;
    std::println("Переменная после изменения: {}", value);
    std::cout << "Переменная после изменения: " << &pointer << std::endl;

    const int numbers[] = {2, 4, 6, 8, 10};

    const int *array_pointer = numbers;

    std::print("Элементы массива: ");
    for (std::size_t i = 0; i < std::size(numbers); ++i) {
        std::cout << (i == 0 ? "" : " ") << *(array_pointer + i);
    }
    std::cout << std::endl;

    int number = 5;
    int *const fixed_pointer = &number;

    std::cout << "До изменения: " << number << std::endl;
    *fixed_pointer = 42;
    std::cout << "После изменения: " << number << std::endl;

    //int another = 99;
    //fixed_pointer = &another;

    return 0;
}