#include "main.h"

#include <stdio.h>

#include "users.h"

int main(void) {
  FILE* db_file = fopen("../users.txt", "r");
  node* users = read_db(db_file);
  fclose(db_file);

  char code[4] = {"\0"};
  char menu_selection = '\0';
  char ch[3];
  int count = 0;

  while (menu_selection != 'e') {
    printf("1 - ввести новый код сети\ne - выход\n");
    scanf("%2s", ch);
    menu_selection = ch[0];

    switch (menu_selection) {
      case '1':
        printf("Введите код сети:  ");
        scanf("%3s", code);

        if (print_users_wirh_code(users, code) != 0) {
          printf("Неверный код\n");
        }

        for (int i = 0; i < 4; i++) code[i] = '\0';
        menu_selection = '\0';
        break;

      case 'e':
        break;

      default:
        menu_selection = '\0';
        printf("Выбран неверный пункт\n");
        break;
    }
  }

  free_node(users);
  return 0;
}
