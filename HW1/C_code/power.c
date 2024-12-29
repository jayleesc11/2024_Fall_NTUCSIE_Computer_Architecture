#include <stdio.h>

int power(int x, int n) {

    if(n == 0) return 1;
    else return x * power(x, n - 1);
}

int main() {
    int x, n;
    printf("Enter the base x: ");
    scanf("%d", &x);
    printf("Enter the power n: ");
    scanf("%d", &n);
    if(x == 0 || x == 1)
        printf("%d^%d = %d\n", x, n, x);
    else
        printf("%d^%d = %d\n", x, n, power(x, n));
    return 0;
}