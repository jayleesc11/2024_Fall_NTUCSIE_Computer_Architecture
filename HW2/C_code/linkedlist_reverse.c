#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct Node {
    int value;
    struct Node *next;
} Node;

typedef struct List {
    Node *head;
} List;

void push_front_list(List *list, int value) {
    if (!list) return;

    Node *new_node = (Node *)malloc(sizeof(Node));
    if (!new_node) {
        perror("malloc failed");
        exit(1);
    }

    new_node->value = value;
    new_node->next = list->head;

    list->head = new_node;
}

// recursively reverse print the list
void print_list(Node *cur) {
    if (!cur) return;
    print_list(cur->next);
    printf("%d ", cur->value);
}

void sort_list(Node *head) {
    if (!head) return;

    Node *cur = head;
    Node *nxt = NULL;
    int temp;
    int swapped;

    // for i = 0 to n
    while (cur) {
        nxt = cur->next;
        swapped = 0;
        // for j = i + 1 to n
        while (nxt) {
            if (cur->value > nxt->value) {
                temp = cur->value;
                cur->value = nxt->value;
                nxt->value = temp;
                swapped = 1;
            }
            nxt = nxt->next;
        }
        cur = cur->next;
        if (swapped == 0) break;
    }
}

int read_int() {
    int value;
    scanf("%d", &value);
    return value;
}

void print_str(const char *str) {
    printf("%s", str);
}

void print_newline() {
    printf("\n");
}

int main() {
    List list = {NULL};
    int nums = read_int();

    if (nums == 0) {
        print_str("Empty!");
        exit(0);
    }

    if (nums <= 0) {
        exit(0);
    }

    while (nums > 0) {
        int value = read_int();
        push_front_list(&list, value);
        nums--;
    }

    print_list(list.head);
    print_newline();

    sort_list(list.head);
    print_list(list.head);

    return 0;
}