import std;

auto main() -> int {
  int a = 150;
  float b = 15.933;
  std::uint_least8_t c = 250;

  std::println("int a = {};", a);
  std::println("float b = {};", b);
  std::println("std::uint_least8_t c = {};", c);

  auto day = 28;
  auto month{"октябрь"};
  auto year = 2006;

  std::println("Моя дата рождения: {} {} {} года", day, month, year);

  const auto d = 2.3;
  const std::string e{"WINDOWS"};

  std::println("{} {}", d, e);
}
