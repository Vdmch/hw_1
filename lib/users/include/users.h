// Copyright [year] <Copyright Owner>

#pragma once

#include <stdio.h>

typedef struct {
  char network_code[4];
  char number[8];
  char* name;
  int len;
} user;

typedef struct node_t {
  user* sel_user;
  struct node_t* next_node;
} node_t;

int free_node(node_t* sel_node);
void free_user(user* sel_user);

int read_user_name(user* sel_user, const char* name, const int len);
int read_number(user* sel_user, const char phone_number[11], const int len);

user* read_user(FILE* data_file);
node_t* read_db(FILE* data_file);

int print_users_wirh_code(node_t* first_node, const char code[4]);
