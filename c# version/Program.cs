
internal class Program
{
    private static void Main(string[] args)
    {
        NNModel model = new NNModel();


        double[,] x_input = { { 1, 0, 1 }, { 1, 1, 1 }, { 1, 0, 0 } };
        double[,] y_output = { { 0, 1, 1 } };

        double[,] weight = model.Training(300, x_input, y_output);

        double[,] question = { { 0, 0, 1 } };
        double[,] result = model.Ask(question, weight);

        Console.Write("model result: ");
        NNModel.PrintMatrix(result);

        string rounded_result = Math.Round(result[0,0]).ToString();

        Console.WriteLine("rounded result: "+rounded_result);
    }

    class NNModel
    {


        public double[,] Ask(double[,] my_input, double[,] weight)
        {
            double[,] output = Divide(Add_number(Exp_matrix(Negative(Multiply(my_input, weight))), 1), 1);
            return output;
        }

        public double[,] Training(int step, double[,] x_input, double[,] y_output)
        {
            double[] history = new double[step];
            double[,] weight = { { 1, 1, 1 } };

            weight = Transpose(weight);

            for (int i = 0; i < step; i++)
            {
                double[,] node_value = Multiply(x_input, weight);
                double[,] predict = Get_diagon(Divide(Add_number(Exp_matrix(Negative(node_value)), 1), 1));
                double[,] d = Derivered_sigmoid(Transpose(predict));


                double[,] error = Add(Transpose(y_output), Get_diagon(Negative(predict)));
                weight = Add(weight, Multiply(Transpose(x_input), Get_diagon(Multiply((error), d))));
                history[i] = Math.Abs(Mean(error));

            }


            return weight;

        }

        public static double[,] Exp_matrix(double[,] matrix)
        {
            double[,] result = new double[matrix.GetLength(0), matrix.GetLength(1)];

            for (int i = 0; i < matrix.GetLength(0); i++)
            {
                for (int j = 0; j < matrix.GetLength(1); j++)
                {
                    result[i, j] = Math.Exp(matrix[i, j]);
                }
            }
            return result;
        }


        public static double[,] Transpose(double[,] matrix)
        {
            double[,] result = new double[matrix.GetLength(1), matrix.GetLength(0)];

            for (int i = 0; i < matrix.GetLength(1); i++)
            {
                for (int j = 0; j < matrix.GetLength(0); j++)
                {
                    result[i, j] = matrix[j, i];
                }

            }
            return result;


        }


        public static double[,] Negative(double[,] matrix)
        {
            double[,] result = new double[matrix.GetLength(0), matrix.GetLength(1)];

            for (int i = 0; i < matrix.GetLength(0); i++)
            {
                for (int j = 0; j < matrix.GetLength(1); j++)
                {
                    result[i, j] = -matrix[i, j];
                }
            }

            return result;
        }


        public static double[,] Divide(double[,] matrix, double d)
        {
            double[,] result = new double[matrix.GetLength(0), matrix.GetLength(1)];

            for (int i = 0; i < matrix.GetLength(0); i++)
            {
                for (int j = 0; j < matrix.GetLength(1); j++)
                {
                    if (matrix[i, j] != 0)
                    {
                        result[i, j] = d / matrix[i, j];
                    }

                }
            }

            return result;
        }

        public static double[,] Add_number(double[,] matrix, double n)
        {
            double[,] result = new double[matrix.GetLength(0), matrix.GetLength(1)];

            for (int i = 0; i < matrix.GetLength(0); i++)
            {
                for (int j = 0; j < matrix.GetLength(1); j++)
                {
                    result[i, j] = matrix[i, j] + n;
                }
            }

            return result;
        }
        public static double[,] Get_diagon(double[,] matrix)
        {

            int row = matrix.GetLength(0);
            int col = matrix.GetLength(1);

            double[,] result = new double[row, 1];

            for (int i = 0; i < row; i++)
            {
                for (int j = 0; j < col; j++)
                {
                    if (i == j)
                    {
                        result[i, 0] = matrix[i, j];
                    }
                }
            }

            return result;
        }


        public double[,] Add(double[,] matrix1, double[,] matrix2)
        {
            int row = matrix1.GetLength(0);
            int col = matrix2.GetLength(1);

            if (matrix2.GetLength(0) != row || matrix2.GetLength(1) != col)
            {
                throw new Exception("check your matrix dims");
            }
            double[,] total_matrix = new double[row, col];
            for (int i = 0; i < row; i++)
            {
                for (int j = 0; j < col; j++)
                {
                    total_matrix[i, j] += matrix1[i, j] + matrix2[i, j];
                }
            }
            return total_matrix;


        }


        public static double[,] Multiply(double[,] matrix1, double[,] matrix2)
        {
            if (matrix1.GetLength(1) != matrix2.GetLength(0))
            {
                throw new Exception("Matrix dimensions are not compatible for multiplication. " +
                                    $"Matrix1 columns: {matrix1.GetLength(1)}, Matrix2 rows: {matrix2.GetLength(0)}");
            }

            int rows = matrix1.GetLength(0);
            int cols = matrix2.GetLength(1);
            int columnDimension = matrix1.GetLength(1);
            double[,] result = new double[rows, cols];

            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < cols; j++)
                {
                    double elementSum = 0;
                    for (int k = 0; k < columnDimension; k++)
                    {
                        elementSum += matrix1[i, k] * matrix2[k, j];
                    }
                    result[i, j] = elementSum;
                }
            }
            return result;
        }


        public static double Mean(double[,] matrix)
        {
            int size = matrix.GetLength(0) * matrix.GetLength(1);
            double[] temp = new double[size];

            int t = 0;
            for (int i = 0; i < matrix.GetLength(0); i++)
            {
                for (int j = 0; j < matrix.GetLength(1); j++)
                {
                    temp[t] = matrix[i, j];
                    t++;
                }
            }
            return Sum(temp) / size;
        }

        public static double Sum(double[] array)
        {
            double sum = 0;
            for (int i = 0; i < array.Length; i++)
            {
                sum += array[i];
            }
            return sum;
        }

        public static double[] Get_dim(double[,] matrix)
        {
            double[] result = { matrix.GetLength(0), matrix.GetLength(1) };
            return result;

        }

        public static double[,] Derivered_sigmoid(double[,] matrix)
        {
            int rows = matrix.GetLength(0);
            int cols = matrix.GetLength(1);
            double[,] result = new double[rows, cols];

            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < cols; j++)
                {
                    result[i, j] = matrix[i, j] * (1 - matrix[i, j]);
                }
            }

            return result;
        }

        public static double Sigmoid(double x)
        {
            return 1 / (1 + Math.Pow(Math.E, -x));
        }



        public static double[,] Generate_I(int n)
        {
            double[,] I = new double[n, n];
            for (int i = 0; i < n; i++)
            {
                I[i, i] = 1;
            }
            return I;
        }
        public static void PrintArray(double[] array)
        {
            for (int i = 0; i < array.Length; i++)
            {
                Console.Write(array[i] + " ");
            }
            Console.WriteLine();
        }

        public static void PrintMatrix(double[,] matrix)
        {
            for (int i = 0; i < matrix.GetLength(0); i++)
            {
                for (int j = 0; j < matrix.GetLength(1); j++)
                {
                    Console.Write(matrix[i, j] + " ");
                }
                Console.WriteLine();
            }
            Console.WriteLine();
        }

    }

}

