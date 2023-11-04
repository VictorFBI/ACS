#include <iostream>

int main() {
  double num;
  const double eps = 0.0005;
  std::cin >> num;
  if (num == 0) {
    std::cout << 0.0;
    return 0;
  }
  double root = num / 3;
  double prev_root;
  double rn;
  do {
    prev_root = root;
    rn = num;
    rn /= root;
    rn /= root;
    root = 0.5 * (root + rn);
  } while (std::abs((root - prev_root) / root) > eps);
  std::cout << root;
  return 0;
}

