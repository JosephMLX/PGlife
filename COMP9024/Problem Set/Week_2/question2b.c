void matrixProduct(float a[M][N], float b[N][P], float c[M][P]) {
	int i, j, k;
	for (i = 0; i < M; i++) {
		for (j = 0; j < P; j++) {
			c[i][j] = 0.0
			for (k = 0; k < N; k++) {
				c[i][j] += a[i][k] * b[k][j];
			}
		}
	}
}