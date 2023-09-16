#include <iostream>

int main() {
  int a, b, quotient = 0;
  std::cout << "Input divisible: ";
  std::cin >> a;
  std::cout << "Input divisor: ";
  std::cin >> b;

  if(b == 0) {
    std::cout << "You cannot divide by zero";
    return 0;
  }

  int k = 1, t = 1, prev_a, pp;

  if (a < 0) k = -1;
  if (b < 0) t = -1;

  if (k < 0) {
    pp = a;
    a -= pp;
    a -= pp;
  }
  if (t < 0) {
    pp = b;
    b -= pp;
    b -= pp;
  }

  prev_a = a;
  int whole = 0;
  while (a >= b) {
    ++quotient;
    whole += b;
    a -= b;
  }

  int remainder = prev_a - whole;

  if (k < 0) {
    pp = quotient;
    quotient -= pp;
    quotient -= pp;
    pp = remainder;
    remainder -= pp;
    remainder -= pp;
  }
  if (t < 0) {
    pp = quotient;
    quotient -= pp;
    quotient -= pp;
  }

  std::cout << "Quotient is " << quotient << "\n" << "Remainder is " << remainder;
  return 0;
}