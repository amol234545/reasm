void printf(const char *, ...);


int main() {
    int matrix[4][4];
    int rowSum[4] = {0};
    int colSum[4] = {0};
    int totalSum = 0;
    int xorAll = 0;
    int productDiag = 1;

    // Fill the matrix with numbers 1..16
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            matrix[i][j] = i * 4 + j + 1;
        }
    }

    // Calculate sums, XOR, and diagonal product
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            rowSum[i] += matrix[i][j];
            colSum[j] += matrix[i][j];
            totalSum += matrix[i][j];
            xorAll ^= matrix[i][j];

            if(i == j) {
                productDiag *= matrix[i][j];
            }
        }
    }

    // Conditional outputs
    for(int i = 0; i < 4; i++) {
        if(rowSum[i] % 2 == 0) {
            printf("Row %d sum is even: %d\n", i, rowSum[i]);
        } else {
            printf("Row %d sum is odd: %d\n", i, rowSum[i]);
        }

        if(colSum[i] % 2 == 0) {
            printf("Column %d sum is even: %d\n", i, colSum[i]);
        } else {
            printf("Column %d sum is odd: %d\n", i, colSum[i]);
        }
    }

    printf("Total sum: %d\n", totalSum);
    printf("XOR of all elements: %d\n", xorAll);
    printf("Product of diagonal elements: %d\n", productDiag);

    // Bitwise manipulations
    int shiftXor = 0;
    for(int i = 0; i < 16; i++) {
        shiftXor |= (i << (i % 4));
    }
    printf("Shift XOR result: %d\n", shiftXor);

    return 0;
}
