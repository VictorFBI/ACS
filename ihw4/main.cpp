#include <iostream>
#include "ConsoleIOController.h"
#include "multithread_omp.h"

void command_IO(char *argv[]) {
  std::string variant(argv[1]);
  int size = 0;
  if (variant != "1" && variant != "2") {
    std::cout << "Wrong variant!";
    return;
  }
  if (variant == "1") {
    size = std::stoi(argv[2]);
    for (auto i = 0; i < size; ++i) {
      buffer.push_back(std::stoi(argv[i + 3]));
    }
  } else {
    if (variant == "2") {
      std::string input_file_name(argv[2]);
      std::ifstream fin(input_file_name);
      ConsoleIOController::read_vector(buffer, fin);
    }
  }

  if (buffer.empty()) {
    std::string filename;
    std::string result = "Buffer is empty!\n";
    std::cout << "Print output file name: ";
    std::cin >> filename;
    std::ofstream out(filename);
    out << result;
    std::cout << result;
    return;
  }

  // Решение поставленной задачи
  multithreaded_solution();

  output.emplace_back("Final vector: ");
  for (auto &el : buffer) {
    output.push_back(std::to_string(el) + ' ');
  }
  output.emplace_back("\nUsed distribution: Uniform(" + std::to_string(left) + ", " + std::to_string(right) + ")\n");

  std::string output_file_name(argv[size + 3]);
  std::ofstream fout(output_file_name);
  ConsoleIOController::print_vector(output, fout);
  ConsoleIOController::print_vector(buffer, std::cout);
  std::cout << "Used distribution: Uniform(" + std::to_string(left) + ", " + std::to_string(right) + ")";
}

void console_IO() {
  std::string filename;
  std::cout << "Do you want to input data manually (1) or from the file (2) ?\n";
  std::cout << "1 or 2 ?\n";
  int variant = ConsoleIOController::get_variant();

  if (variant == 1) {
    ConsoleIOController::read_vector(buffer, std::cin);
  } else {
    std::cout << "Enter the name of the file: ";
    std::cin >> filename;
    ConsoleIOController::give_valid_file_name(filename);
    std::ifstream in(filename);

    ConsoleIOController::read_vector(buffer, in);
  }



  // Логика программы, если на вход пришёл пустой буффер
  if (buffer.empty()) {
    std::string result = "Buffer is empty!\n";
    std::cout << "Print output file name: ";
    std::cin >> filename;
    std::ofstream out(filename);
    out << result;
    std::cout << result;
    return;
  }

  // Решение поставленной задачи
  multithreaded_solution();

  // Логика по выводу полученного результата
  std::cout << "Print output file name: ";
  std::cin >> filename;
  std::cout << "Final vector: ";
  ConsoleIOController::print_vector(buffer, std::cout);
  std::cout << "Used distribution: Uniform(" + std::to_string(left) + ", " + std::to_string(right) + ")";
  std::ofstream out(filename);
  output.emplace_back("Final vector: ");
  for (auto &el : buffer) {
    output.push_back(std::to_string(el) + ' ');
  }
  output.emplace_back("\nUsed distribution: Uniform(" + std::to_string(left) + ", " + std::to_string(right) + ")\n");
  ConsoleIOController::print_vector(output, out);
}

int main(int argc, char *argv[]) {
  if (argc > 1) {
    command_IO(argv);
  } else {
    console_IO();
  }

  return 0;
}