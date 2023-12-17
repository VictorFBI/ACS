#include <iostream>
#include <algorithm>
#include <fstream>
#include <pthread.h>
#include <vector>
#include "uniform_random.h"

// Объявление необходимых глобальных переменных
std::vector<int> buffer; // буфер с числами
std::vector<std::string> output; // вектор для хранения вывода всей программы (для дальнейшей записи в файл)
bool is_read_stream_active =
    false; // условная переменная (true, если есть хотя бы один активный поток-читатель, false иначе)
pthread_rwlock_t rwlock;  //блокировка чтения-записи
pthread_mutex_t mutex_print; // мьютекс для записи
pthread_mutex_t mutex_cond; // мьютекс для условной переменной
int num_of_record = 1; // номер записи в буфере


// Функция записи в буфер (выполняется несколькими потоками)
void *write_nums(void *args) {
  int num_thread = *static_cast<int *>(args);
  pthread_rwlock_wrlock(&rwlock);
  while (is_read_stream_active) {

  }
  int index = dice() % static_cast<int>(buffer.size());
  int key = dice();
  int old = buffer[index];
  buffer[index] = key;
  pthread_mutex_lock(&mutex_print);
  std::string outstr = "[write] " + std::to_string(num_of_record++) + ". Thread number " + std::to_string(num_thread) +
      " changed the value of record with id " + std::to_string(index) +
      " from " + std::to_string(old) + " to " + std::to_string(key) + '\n';
  std::cout << outstr;
  output.push_back(outstr);
  pthread_mutex_unlock(&mutex_print);
  std::sort(buffer.begin(), buffer.end());
  pthread_rwlock_unlock(&rwlock);
  return nullptr;
}

// Функция чтения из буфера (выполняется несколькими потоками)
void *read_nums(void *args) {
  pthread_mutex_lock(&mutex_cond);
  is_read_stream_active = true;
  pthread_mutex_unlock(&mutex_cond);
  int num_thread = *static_cast<int *>(args);
  int index = dice() % static_cast<int>(buffer.size());
  pthread_mutex_lock(&mutex_print);
  std::string outstr = "[read] " + std::to_string(num_of_record++) + ". Thread number " + std::to_string(num_thread) +
      " read the record with id " + std::to_string(index)
      + " and " + " value " + std::to_string(buffer[index]) + '\n';
  std::cout << outstr;
  output.push_back(outstr);
  pthread_mutex_unlock(&mutex_print);
  pthread_mutex_lock(&mutex_cond);
  is_read_stream_active = false;
  pthread_mutex_unlock(&mutex_cond);
  return nullptr;
}

// Функция, реализующая многопоточное решение
void multithreaded_solution() {
  pthread_rwlock_init(&rwlock, nullptr);
  pthread_mutex_init(&mutex_print, nullptr);

  pthread_t write_thread[20];
  pthread_t read_thread[20];
  int writers[20];
  int readers[20];

  for (auto i = 0; i < 20; ++i) {
    writers[i] = i + 1;
    readers[i] = i + 1;
    pthread_create(&write_thread[i], nullptr, write_nums, (void *) (writers + i));
    pthread_create(&read_thread[i], nullptr, read_nums, (void *) (readers + i));
  }

  for (auto i = 0; i < 20; ++i) {
    pthread_join(write_thread[i], nullptr);
    pthread_join(read_thread[i], nullptr);
  }

  // Уничтожение синхропримитивов
  pthread_rwlock_destroy(&rwlock);
  pthread_mutex_destroy(&mutex_print);
}