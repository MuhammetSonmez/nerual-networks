public class Main {

    public static double[][] training(int step, double[][]x_input, double[][]y_output){
        Utils utils = new Utils();
        double[] history = new double[step];
        double[][] weight = {{1,1,1}};
        weight = utils.transpose(weight);
        for (int i = 0; i < step; i ++){
            double[][]node_value = utils.multiply(x_input, weight);
            double[][] predict = utils.get_diagon(utils.divide(utils.add_number(utils.exp(utils.negative(node_value)), 1), 1));
            double[][] d = utils.derived_sigmoid(utils.transpose(predict));
            double error[][] = utils.add(utils.transpose(y_output), utils.get_diagon(utils.transpose(utils.negative(predict))));
            weight = utils.add(weight, utils.multiply(utils.transpose(x_input), utils.get_diagon(utils.multiply((error), d))));
            history[i] = utils.abs(utils.mean(error));

        }
        return weight;
    }
    
    public static double[][] ask(double[][]my_input, double[][]weight){
        Utils utils = new Utils();
        double output[][] = utils.divide(utils.add_number(utils.exp(utils.negative(utils.multiply(my_input, weight))),1), 1);
        return output;
    }

    public static void main(String[] args) {
        double[][] x_input = {{1,0,1},{1,1,1},{1,0,0}};
        double[][] y_output = {{0,1,1}};
        double [][] weight = training(300, x_input, y_output);

        double[][] question = {{1, 0, 0}};
        double[][] result = ask(question, weight);
        System.out.printf("%.15f\n",result[0][0]);
        
    }

}
