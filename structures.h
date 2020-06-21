struct Data {
  char data;
  char num;
};

struct Node {
  struct Data data;
  struct Node *left, *right;
};
