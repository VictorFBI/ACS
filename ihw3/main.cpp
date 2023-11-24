#include <cmath>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

const std::string rarsExecutablePath = R"(C:\Users\frolo\rars1_6.jar)";
const std::string assemblyFilePath = R"( D:\asm\ihw3\main.asm)";

int main() {
  std::string testFilePath = R"(D:\asm\ihw3\tests.txt)";
  std::ifstream fin(testFilePath);
  std::string filePath;
  std::string substring;
  std::string ansPath;
  std::string yesOrNo;
  std::vector<std::string> data{"Sample data", "a roza upala na lapu azora", "", "no answer", "123456789", "Rancho kk", "3blue1brown", "0", "red dead redemption", "federer"};
  int i = 1;
  for (auto& el : data) {
    filePath = R"(D:\asm\ihw3\file)" + std::to_string(i++) + ".txt";
    std::ofstream fout(filePath);
    fout << el;
  }

  // Generating of separate test files
  i = 1;
  while (fin >> filePath) {
    fin >> substring;
    fin >> ansPath;
    fin >> yesOrNo;
    std::string separateTestFilePath = R"(D:\asm\ihw3\test)" + std::to_string(i++) + ".txt";
    std::ofstream fout(separateTestFilePath);
    filePath = R"(D:\asm\ihw3\)" + filePath; // NOLINT
    ansPath = R"(D:\asm\ihw3\)" + ansPath; // NOLINT
    fout << filePath << '\n';
    fout << substring << '\n';
    fout << ansPath << '\n';
    fout << yesOrNo << '\n';
  }

  // Calling our program with generated test files
  for (auto j = 1; j < i; ++j) {
    std::string command = "java -jar " + rarsExecutablePath
        + assemblyFilePath + " < " + R"(D:\asm\ihw3\test)"
        + std::to_string(j) + ".txt";
    system(command.c_str());
    std::cout << "\n------------------------------------\n";
  }

  return 0;
}