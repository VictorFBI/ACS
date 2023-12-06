#include <iostream>
#include <ctime>
#include <iomanip>
#include <pthread.h>

#define NUM_THREADS 1000
#define ARR_SIZE 800000000

struct Package {
  double *A;
  double *B;
  int thread_num;
  double res;
};

void *func(void *param) {
  auto package = static_cast<Package *>(param);
  for (auto i = package->thread_num; i < ARR_SIZE; i += NUM_THREADS) {
    package->res += package->A[i] * package->B[i];
  }
  return nullptr;
}

double *create_array1(int n) {
  auto array = new double[n];
  for (auto i = 0; i < n; ++i) {
    array[i] = i + 1;
  }
  return array;
}

double *create_array2(int n) {
  auto array = new double[n];
  for (auto i = 0; i < n; ++i) {
    array[i] = n - i;
  }
  return array;
}

int main() {
  double ans_async = 0;
  double ans_single = 0;
  auto array1 = create_array1(ARR_SIZE);
  auto array2 = create_array2(ARR_SIZE);

  clock_t start_single = clock();
  for (auto i = 0; i < ARR_SIZE; ++i) {
    ans_single += array1[i] * array2[i];
  }
  clock_t end_single = clock();

  clock_t start_async = clock();
  pthread_t threads[NUM_THREADS];
  Package data[NUM_THREADS];

  for (auto i = 0; i < NUM_THREADS; ++i) {
    data[i].A = array1;
    data[i].B = array2;
    data[i].thread_num = i;
    data[i].res = 0;
    pthread_create(&threads[i], nullptr, func, static_cast<void *>(&data[i]));
  }

  for (auto i = 0; i < NUM_THREADS; ++i) {
    pthread_join(threads[i], nullptr);
    ans_async += data[i].res;
  }

  clock_t end_async = clock();
  std::cout << "Number of elements is " << ARR_SIZE << '\n';
  std::cout << "Scalar product (single) = " << std::setprecision(20) << std::scientific << ans_single << '\n';
  std::cout << "Time of program execution (single) = " << std::defaultfloat << double(end_single - start_single) / CLOCKS_PER_SEC << " seconds" << '\n';
  std::cout << "Number of threads is " << NUM_THREADS << "\n";
  std::cout << "Scalar product (async) = " << std::setprecision(20) << std::scientific << ans_async << '\n';
  std::cout << "Time of program execution (async) = " << std::defaultfloat << double(end_async - start_async) / CLOCKS_PER_SEC << " seconds";

  delete[] array1;
  delete[] array2;
  return 0;
}
