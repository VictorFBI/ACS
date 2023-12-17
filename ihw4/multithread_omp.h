#include <iostream>
#include <algorithm>
#include <fstream>
#include <omp.h>
#include <vector>
#include "uniform_random.h"

// Объявление необходимых глобальных переменных
std::vector<int> buffer; // буфер с числами
std::vector<std::string> output; // вектор для хранения вывода всей программы (для дальнейшей записи в файл)
bool is_read_stream_active =
    false; // условная переменная (true, если есть хотя бы один активный поток-читатель, false иначе)
int num_of_record = 1; // номер записи в буфере


// Функция записи в буфер (выполняется несколькими потоками)
void write_nums(int num_thread) {
#pragma omp critical
  {
    while (is_read_stream_active) {} // ожидание, пока не закончится чтение
    int index = dice() % static_cast<int>(buffer.size());
    int key = dice();
    int old = buffer[index];
    buffer[index] = key;
#pragma omp critical (cout)
    {
      std::string
          outstr = "[write] " + std::to_string(num_of_record++) + ". Thread number " + std::to_string(num_thread) +
          " changed the value of record with id " + std::to_string(index) +
          " from " + std::to_string(old) + " to " + std::to_string(key) + '\n';
      std::cout << outstr;
      output.push_back(outstr);
    }
    std::sort(buffer.begin(), buffer.end());
  }
}

// Функция чтения из буфера (выполняется несколькими потоками)
void read_nums(int num_thread) {
#pragma omp critical
  {
#pragma omp critical (cond)
    {
      is_read_stream_active = true;
    }
    int index = dice() % static_cast<int>(buffer.size());
#pragma omp critical (cout)
    {
      std::string
          outstr = "[read] " + std::to_string(num_of_record++) + ". Thread number " + std::to_string(num_thread) +
          " read the record with id " + std::to_string(index)
          + " and " + " value " + std::to_string(buffer[index]) + '\n';
      std::cout << outstr;
      output.push_back(outstr);
    }
#pragma omp critical (cond)
    {
      is_read_stream_active = false;
    }
  }
}

// Функция, реализующая многопоточное решение
void multithreaded_solution() {
#pragma omp parallel num_threads(20)
  {
    int num_thread = omp_get_thread_num();
    if (num_thread % 2 == 0) {
      write_nums(num_thread);
    } else {
      read_nums(num_thread);
    }
  }
}