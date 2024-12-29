#include <stdio.h>

int T(int n) {
    if(n == 0) return 0;
    else if(n == 1) return 1;
    else return 2 * T(n - 1) + T(n - 2);
}

int main() {
    int n;
    printf("Enter the number n: ");
    scanf("%d", &n);
    printf("T(%d) = %d\n", n, T(n));
    return 0;
}