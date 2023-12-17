#include <iostream>
#include <chrono>
#include <random>
#include <functional>

// Задаём хороший генератор случайных чисел, с seed, привязанным к текущему времени
unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
std::default_random_engine generator(seed); // NOLINT
// Берем равномерное распределение от 0 до 1000
std::uniform_int_distribution<int> helper(0, 1000);
auto helper_dice = std::bind(helper, generator); // NOLINT
// С помощью вспомогательного генератора создаем равномерное распределение со случайными границами
int left = helper_dice();
int right = left + 1000;
std::uniform_int_distribution<int> distribution(left, right);
auto dice = std::bind(distribution, generator); // NOLINT