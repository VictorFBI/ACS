#include <fstream>
#include <iostream>
#include <string>
#include <vector>

const std::string rarsExecutablePath = R"(C:\Users\frolo\rars1_6.jar)";
const std::string assemblyFilePath = R"( D:\asm\ihw1\main.asm)";

int main() {
  std::vector<std::string> vec;

  for (std::size_t i = 0; i < 10; ++i) {
    std::string str = "java -jar " + rarsExecutablePath
        + assemblyFilePath + " < " + R"(D:\asm\ihw1\test_case)"
        + std::to_string(i + 1) + ".txt";
    vec.push_back(str);
  }

  for (std::size_t i = 0; i < vec.size(); ++i) {
    std::string testFilePath = R"(D:\asm\ihw1\test_case)"
        + std::to_string(i + 1) + ".txt";
    std::ifstream fin(testFilePath);
    std::cout << i + 1 << ". File content: ";
    while (!fin.eof()) {
      int num;
      fin >> num;
      std::cout << num << " ";
    }
    std::cout << '\n';
    const char *command = vec[i].c_str();
    system(command);
    std::cout << "\n------------------------------------\n";
  }
  return 0;
}
