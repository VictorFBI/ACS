#include <cmath>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

const std::string rarsExecutablePath = R"(C:\Users\frolo\rars1_6.jar)";
const std::string assemblyFilePath = R"( D:\asm\ihw2\main.asm)";

int main() {
  std::vector<double> vec;
  std::string testFilePath = R"(D:\asm\ihw2\tests.txt)";
  std::ifstream fin(testFilePath);
  std::cout << "File content: ";
  int i = 1;
  double num;
  while (fin >> num) {
    std::string new_test_file_path = R"(D:\asm\ihw2\test)" + std::to_string(i) + ".txt";
    std::ofstream fout;
    fout.open(new_test_file_path);
    fout << num;
    fout.close();
    vec.push_back(num);
    std::cout << num << " ";
    ++i;
  }
  std::cout << '\n';
  for (auto j = 1; j < i; ++j) {
    std::cout << "\n";
    std::cout << j << ". ";
    std::string command = "java -jar " + rarsExecutablePath
        + assemblyFilePath + " < " + R"(D:\asm\ihw2\test)"
        + std::to_string(j) + ".txt";
    system(command.c_str());
    std::cout << " (Library method: " << std::cbrt(vec[j - 1]) << ")\n";
  }
  return 0;
}
