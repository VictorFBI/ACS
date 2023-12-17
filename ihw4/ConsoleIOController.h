#include <iostream>
#include <filesystem>
#include <vector>

// Класс, отвечающий за реализацию реализацию правильного взаимодействия пользователя с программой
class ConsoleIOController {
 public:
  ConsoleIOController() = default;
  ~ConsoleIOController() = default;

  // Чтение в вектор с использованием переданного потока ввода
  static void read_vector(std::vector<int> &vec, std::istream &in) {
    int size;
    in >> size;
    vec = std::vector<int>(size);
    for (auto i = 0; i < size; ++i) {
      in >> vec[i];
    }
  }

  // Метод, работающий до тех пор, пока пользователь не введёт существующий файл
  static void give_valid_file_name(std::string &str) {
    while (!std::filesystem::exists(str)) {
      std::cout << "File with this name does not exist. Try another name: ";
      std::cin >> str;
    }
  }

  // Функция, запрашивающая ввод у пользователя, пока он не введёт 1 или 2 и возвращающая введенный вариант
  static int get_variant() {
    std::string variant;
    std::cout << "Your variant: ";
    std::cin >> variant;
    while (variant != "1" && variant != "2") {
      std::cout << "Incorrect input. Try again: ";
      std::cin >> variant;
    }
    return variant == "1" ? 1 : 2;
  }

  // Функция, печатающая вектор с использованием переданного потока вывода
  template<class T>
  static void print_vector(std::vector<T> &vec, std::ostream &out) {
    for (T &i : vec) {
      out << i << ' ';
    }
    out << '\n';
  }
};