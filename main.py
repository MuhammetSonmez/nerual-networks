from util.matrix import *
from util.activation import *

#data
x_input = [[0,0,1], [1,1,1], [1,0,0]]
y_output = transpose([[0,1,1]])

#training
def training(step):
    history = []
    weight = transpose([[1,1,1]])#random values
    for i in range(step):
        node_value = multiple(x_input, weight)
        predict = divide(add_number(exp(negative(node_value)),1), 1)#sigmoid function
        d = derived_sigmoid(transpose(predict))
        error = add(y_output, negative(predict))
        weight = add(weight, multiple(transpose(x_input),get_diagon(multiple((error), d))))
        #print(abs(mean(error)))
        history.append(abs(mean(error)))
    return weight, history



def ask(my_input, weight):
    output = divide(add_number(exp(negative(multiple(my_input, weight))),1), 1)
    return output

weight, history = training(300)

result = ask([[1,0,0]], weight)
print("rounded result: ",round(result[0][0]))
print("result: ",result)

