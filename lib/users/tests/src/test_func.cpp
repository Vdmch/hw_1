#include <gtest/gtest.h>
#include <iostream>

extern "C" {
#include "users.h"
}


// Функция read_number() не принимает неправильные значения номера

TEST(read_number_func, nan_return){
  user test_user = user();

  char tst_number1[] = "bcdefghijk";
  int returned = read_number(&test_user, tst_number1, strlen(tst_number1));
  if (returned != 0) SUCCEED();
  else FAIL();

  char tst_number2[] = "000000000";
  returned = read_number(&test_user, tst_number2, strlen(tst_number2));
  if (returned != 0) SUCCEED();
  else FAIL();
  
  char tst_number3[] = "00000000000";
  returned = read_number(&test_user, tst_number3, strlen(tst_number3));
  if (returned != 0) SUCCEED();
  else FAIL();
}


// Функция read_number() корректно принимает правильные значения номера

TEST(read_number_func, number_check){  
  user test_user = user();

  char tst_number[] = "1234567895";
  int returned = read_number(&test_user, tst_number, strlen(tst_number));
  
  if (returned == 0) SUCCEED();
  else FAIL();
  
  EXPECT_EQ(tst_number[0], test_user.network_code[0]);
  EXPECT_EQ(tst_number[1], test_user.network_code[1]);
  EXPECT_EQ(tst_number[2], test_user.network_code[2]);
  EXPECT_EQ('\0', test_user.network_code[3]);

  for(int i = 0; i < 8; i++){
    EXPECT_EQ(tst_number[i+3], test_user.number[i]);
  }
}

// Функция readName() не принимает неправильные имена

TEST(read_name_func, nan_return){
  user test_user = user();

  char tst_name0[] = "qwert?s";
  int returned = read_user_name(&test_user, tst_name0, strlen(tst_name0));
  if (returned != 0) SUCCEED();
  else FAIL();
  free(test_user.name);

  char tst_name1[] = "qwerts/n";
  returned = read_user_name(&test_user, tst_name1, strlen(tst_name1));
  if (returned != 0) SUCCEED();
  else FAIL();
  free(test_user.name);

  char tst_name2[] = "";
  returned = read_user_name(&test_user, tst_name2, strlen(tst_name2));
  if (returned != 0) SUCCEED();
  else FAIL();
  free(test_user.name);
}


// Функция readName() корректно принимает правильные значения номера

TEST(read_name_func, name_check){
  user test_user = user();

  char tst_name[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  int returned = read_user_name(&test_user, tst_name, strlen(tst_name));
  
  if (returned == 0) SUCCEED();
  else FAIL();

  EXPECT_STREQ(test_user.name,tst_name); 
  EXPECT_EQ(test_user.len,strlen(tst_name));
  free(test_user.name);
}


// Функция read_user() корректно считывает пользователей из файла
 
TEST(read_user_func, check){
  FILE* tst_file = fopen("../../../../lib/users/tests/test_users.txt", "r");
  

  if(tst_file == NULL) FAIL();

  user* result = read_user(tst_file);
  
  if (result != NULL) SUCCEED();
  else FAIL();

  EXPECT_STREQ("bdUjt", result->name); 
  EXPECT_STREQ("457", result->network_code); 
  EXPECT_STREQ("3117008", result->number); 
  free_user(result);

  
  result = read_user(tst_file);

  if (result != NULL) SUCCEED();
  else FAIL();

  EXPECT_STREQ("lUL", result->name); 
  EXPECT_STREQ("901", result->network_code); 
  EXPECT_STREQ("6582556", result->number); 
  free_user(result);
  fclose(tst_file);
}



// Функция read_db() не вызывает утечек памяти

TEST(read_db_func, memleak){
  FILE* tst_file = fopen("../../../../lib/users/tests/test_users.txt", "r");
  if(tst_file == NULL) FAIL();

  node* first_node = read_db(tst_file);
  fclose(tst_file);


  int users_free = free_node(first_node);

  EXPECT_EQ(100, users_free); 
}

int main(int argc, char **argv){
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
