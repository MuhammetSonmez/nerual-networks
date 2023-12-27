public class Utils {
   public double e = eexp(1);

   public double pow(double a, double b) {
    if (a == 0 && b < 0) {
        throw new ArithmeticException("0.0 cannot be raised to a negative power");
    }

    if (b < 0) {
        return 1.0 / powHelper(a, -b);
    } else {
        return powHelper(a, b);
    }
}

    public double eexp(double x) {
        final int terms = 10; // Terim sayısı
        double result = 1.0;
        double factorial = 1.0;

        for (int i = 1; i <= terms; i++) {
            factorial *= i;
            result += Math.pow(x, i) / factorial;
        }

        return result;
    }

    private double powHelper(double a, double b) {
        if (b == 0) {
            return 1;
        } else if (b == 1) {
            return a;
        } else {
            double half = powHelper(a, b / 2);
            if (b % 2 == 0) {
                return half * half;
            } else {
                return a * half * half;
            }
        }
    }
    
    
    public double eexp(int x, int terms){
        double result = 1.0;
        double factorial = 1.0;
        for (int i = 1; i < terms + 1; i++){
            factorial = factorial * i;
            result = result + (pow(x,i))/factorial;
        }
        return result;

    }
    public double sigmoid(double x){
        return 1/(1 + pow(e, (-x)));
    }

    public double[][] derived_sigmoid(double[][] matrix) {
        int rows = matrix.length;
        int cols = matrix[0].length;
        double[][] result = new double[rows][cols];

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                result[i][j] = matrix[i][j] * (1 - matrix[i][j]);
            }
        }
        return result;
    }

    public double[] get_dim(double[][] matrix){
        double[] result = {matrix.length, matrix[0].length};
        return result;
    }

    public void printArray(double[] array) {
        for (int i = 0; i < array.length; i++) {
                System.out.print(array[i] + " ");
            }
            System.out.println();
    }
    public void printMatrix(double[][] matrix){
        for (int i = 0; i < matrix.length; i ++){
            for (int j = 0; j < matrix[0].length; j ++){
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }
    }

    public double sum(double[] arr){
        double sum = 0;
        for (int i = 0; i < arr.length; i ++){
            sum += arr[i];
        }
        return sum;
    }
    
    public double mean(double[][] matrix){
        int size = matrix.length * matrix[0].length;
        double[] temp = new double[size];

        int t = 0;
        for(int i = 0; i < matrix.length; i ++){
            for (int j = 0; j < matrix[0].length;j++){
                temp[t] = matrix[i][j];
                t++;
            }
        }
        return sum(temp)/(matrix.length * matrix[0].length);

    }

    public double[][] multiply(double[][] matrix1, double[][] matrix2) {
        if (matrix1[0].length != matrix2.length) {
            System.out.println("Check your matrix dimensions");
            return null;
        }
    
        int rows = matrix1.length;
        int cols = matrix2[0].length;
        int commonDimension = matrix1[0].length;
    
        double[][] result = new double[rows][cols];
    
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                double elementSum = 0;
                for (int k = 0; k < commonDimension; k++) {
                    elementSum += matrix1[i][k] * matrix2[k][j];
                }
                result[i][j] = elementSum;
            }
        }
    
        return result;
    }

    public double[][] add(double[][]matrix1, double[][]matrix2){
        int row_count = matrix1.length;
        int col_count = matrix2[0].length;

        if (matrix2.length!= row_count || matrix2[0].length != col_count){
            System.out.println("Check your matrix dims");
            printArray(get_dim(matrix1));
            printArray(get_dim(matrix2));
        }

        double[][] total_matrix = new double[row_count][col_count];

        for (int i = 0; i < row_count; i ++){
            for (int j = 0; j < col_count; j ++){
                total_matrix[i][j] = matrix1[i][j] + matrix2[i][j];
            }
        }
        return total_matrix;
    }
    
    public double[][] get_diagon(double[][] matrix) {
        int numRows = matrix.length;
        int numCols = matrix[0].length;

        double[][] result = new double[numRows][1];

        for (int i = 0; i < numRows; i++) {
            for (int j = 0; j < numCols; j++) {
                if (i == j) {
                    result[i][0] = matrix[i][j];
                }
            }
        }

        return result;
    }

    public double[][] add_number(double[][]matrix, double n){
        double[][] result = new double[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix.length; i ++){
            for (int j = 0; j < matrix[0].length; j ++){
                result[i][j] = matrix[i][j] + n;
            }
        }
        return result;
    }

    public double[][] generate_I(int n){
        double[][] I = new double[n][n];
        for(int i = 0; i < n; i ++){
            I[i][i] = 1;
        }
        return I;
    }

    public double[][] divide(double [][] matrix, double d){
        double[][] result = new double[matrix.length][matrix[0].length];

        for (int i = 0; i < matrix.length; i ++){
            double[] row = new double[matrix.length];
            for(int j = 0; j < matrix[0].length; j ++){
                row[j] = (d/matrix[i][j]);
            }
            result[i] = row;
        }

        return result;

    }
    public double[][] negative(double [][] matrix){
        double[][] result = new double[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix.length; i ++){
            double[] row = new double[matrix.length];
            for(int j = 0; j < matrix[0].length; j ++){
                row[i] = (-1 *matrix[i][j]);
            }
            result[i] = row;
        }

        return result;

    }
    /*
    public double[][] transpose(double[][] matrix){
        double[][] result = new double[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix[0].length; i ++){
            double[] row = new double[matrix.length];
            for (int j = 0; j < matrix.length; j++){
                row[j] = matrix[j][i];
            }
            result[i] = row;
        }
        return result;
    }*/
    public double[][] transpose(double[][] matrix) {
        double[][] result = new double[matrix[0].length][matrix.length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[0].length; j++) {
                result[j][i] = matrix[i][j];
            }
        }
        return result;
    }
    
    public double[][] exp(double[][]matrix){
        double[][] result = new double[matrix.length][matrix[0].length];

        for (int i = 0; i < matrix.length; i ++){
            double[] row = new double[matrix.length];
            for(int j = 0;j < matrix[0].length; j ++){
                row[i] = eexp(matrix[i][j]);
            }

            result[i] = row;

        }
        return result;

    }
    public double abs(double x){
        if(x > 0){
            return x;
        }
        else if(x < 0){
            return -x;
        }
        else{
            return 0;
        }

    }

}

