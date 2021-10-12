#include "users.h"

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

// Функция добавления номера пользователя

int read_number(user* sel_user, const char phone_number[11], const int len) {
  if (len != 10) return 1;
  // Проверяем номер на корректность
  for (int i = 0; i < 10; i++) {
    if (!isdigit(phone_number[i])) return 1;
  }
  if (phone_number[10] != '\0') return 1;

  // Копируем номер
  memcpy(sel_user->network_code, phone_number, 3);
  sel_user->network_code[3] = '\0';

  memcpy(sel_user->number, phone_number + 3, 8);

  return 0;
}

// Функция добавления имени пользователя

int read_user_name(user* sel_user, const char* name, const int len) {
  // Проверяем имя на корректность
  if (len < 1) return 1;

  for (int i = 0; i < len; i++) {
    if (!isalpha(name[i])) return 1;
  }

  if ((name[len] != '\0') && (name[len] != '\n')) return 1;

  sel_user->name = (char*)malloc(sizeof(char) * (len + 1));
  if (sel_user->name == NULL) return 1;

  // Копируем имя
  memcpy(sel_user->name, name, len + 1);
  sel_user->len = len;

  return 0;
}

// Функции очитки памяти

void free_user(user* sel_user) {
  if (sel_user) {
    if (sel_user->name) free(sel_user->name);
    free(sel_user);
  }
}

int free_node(node* sel_node) {
  int counter = 0;

  node* next_node = NULL;
  while (sel_node != NULL) {
    next_node = sel_node->next_node;

    if (sel_node->sel_user) free_user(sel_node->sel_user);
    free(sel_node);

    sel_node = next_node;
    counter++;
  }
  return counter;
}

// Функция добавления пользователя из файла

user* read_user(FILE* data_file) {
  char buff[100] = {'\0'};
  int n_char = 0;
  if (data_file == NULL) return NULL;

  // Выделяем память для пользователя
  user* new_user = (user*)malloc(sizeof(user));
  if (new_user == NULL) return NULL;

  new_user->name = NULL;

  int error = 0;
  // Читаем данные из файла и добавляем номер и имя
  n_char = fscanf(data_file, "%99s", buff);
  if (n_char != EOF) {
    error |= read_number(new_user, buff, strlen(buff));
  } else
    error = 1;

  n_char = fscanf(data_file, "%99s", buff);
  if (n_char != EOF) {
    error |= read_user_name(new_user, buff, strlen(buff));
  } else
    error = 1;

  // Если произошла ошибка - очищаем память
  if (error) {
    free_user(new_user);
    return NULL;
  }

  return new_user;
}

// Функция добавления пользователей из файла

node* read_db(FILE* data_file) {
  if (data_file == NULL) return NULL;

  // Создаем первую ноду
  node* first_node = (node*)malloc(sizeof(node));
  if (first_node == NULL) return NULL;

  // Заполняем первого пользователя
  node* selNode = first_node;
  selNode->sel_user = read_user(data_file);

  if (first_node->sel_user == NULL) {
    free(first_node);
    return NULL;
  }

  user* first_user = read_user(data_file);

  // Добавляем пока не получим ошибку чтения пользователя
  while (first_user != NULL) {
    node* next_node = (node*)malloc(sizeof(node));
    if (next_node == NULL) {
      free_user(first_user);
      return NULL;
    }

    selNode->next_node = next_node;
    selNode = next_node;

    selNode->sel_user = first_user;
    selNode->next_node = NULL;

    first_user = read_user(data_file);
  }

  return first_node;
}

// Выводим ользователей с заданным кодом сети

int print_users_wirh_code(node* first_node, const char code[4]) {
  for (int i = 0; i < 3; i++) {
    if (!isdigit(code[i])) return 1;
  }
  if (code[3] != '\0') return 1;
  user* sel_user = NULL;
  printf("Найденные пользователи: \n");
  for (node* next_node = first_node; next_node != NULL;
       next_node = next_node->next_node) {
       sel_user = next_node->sel_user;

    if (!strcmp(sel_user->network_code, code)) {
      printf("    %s%s  %s\n", sel_user->network_code, sel_user->number,
             sel_user->name);
    }
  }

  printf("\n");
  return 0;
}
