void printf(const char *, ...);

#define ROWS 3
#define COLS 3

int main() {
    // Define two 3x3 matrices
    int matrix1[ROWS][COLS] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };

    int matrix2[ROWS][COLS] = {
        {9, 8, 7},
        {6, 6, 4},
        {3, 2, 1}
    };

    int sum[ROWS][COLS];  // To store the result

    // Add the matrices
    for(int i = 0; i < ROWS; i++) {
        for(int j = 0; j < COLS; j++) {
            sum[i][j] = matrix1[i][j] + matrix2[i][j];
        }
    }

    // Print the resulting matrix
    printf("Result of matrix addition:");
    for(int i = 0; i < ROWS; i++) {
        for(int j = 0; j < COLS; j++) {
            printf("%d", sum[i][j]);
        }
    }

    return 0;
}
