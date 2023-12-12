#include <iostream>
#include <pthread.h>
#include <queue>
#include <unistd.h>

std::queue<int> queue;
int key = 1;
pthread_mutex_t mut;
pthread_mutex_t mut_write;
pthread_mutex_t mut_out;

void *write_nums(void *args) {
  int num_thread = *((int *) args);
  pthread_mutex_lock(&mut_write);
  queue.push(key);
  //sleep(rand() % 7 + 1);
  std::cout << "Number " << key++
            << " was written to the array by the thread number " << num_thread << "\n";
  pthread_mutex_unlock(&mut_write);
  return nullptr;
}

struct Package {
  Package(int _a, int _b) : a(_a), b(_b) {}
  int a;
  int b;
};

void *sum_two_nums(void *args) {
  pthread_mutex_lock(&mut_out);
  auto pack = (Package *) args;
  //sleep(rand() % 4 + 3);
  std::cout << "Numbers " << pack->b << " and " << pack->a << " was summed\n";
  queue.push(pack->b + pack->a);
  pthread_mutex_unlock(&mut_out);
  return nullptr;
}

void *check_is_pair(void *args) {
  sleep(1);
  while(true) {
    pthread_mutex_lock(&mut);
    if (queue.size() >= 2) {
      pthread_t sum_thread;
      int a = queue.front();
      queue.pop();
      int b = queue.front();
      queue.pop();
      pthread_mutex_unlock(&mut);
      auto package = new Package(a, b);
      pthread_create(&sum_thread, nullptr, sum_two_nums, (void *) package);
      pthread_join(sum_thread, nullptr);
    } else {
      pthread_mutex_unlock(&mut);
      break;
    }

  }

  return nullptr;
}

int main() {
  queue = std::queue<int>();

  pthread_mutex_init(&mut, nullptr);
  pthread_mutex_init(&mut_write, nullptr);
  pthread_mutex_init(&mut_out, nullptr);

  pthread_t write_thread[20];
  pthread_t checker;
  int writers[20];

  for (auto i = 0; i < 20; ++i) {
    writers[i] = i + 1;
    pthread_create(&write_thread[i], nullptr, write_nums, (void *) (writers + i));
  }
  pthread_create(&checker, nullptr, check_is_pair, nullptr);

  for (auto i = 0; i < 20; ++i) {
    pthread_join(write_thread[i], nullptr);
  }
  pthread_join(checker, nullptr);

  pthread_mutex_destroy(&mut);
  pthread_mutex_destroy(&mut_write);
  pthread_mutex_destroy(&mut_out);

  sleep(2);

  std::cout << "Total sum is " << queue.front();

  return 0;
}