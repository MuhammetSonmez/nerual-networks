import util.mat as mat

#sigmoid
def sigmoid(x):
    return 1/(1+mat.e**(-1 * x))

def derived_sigmoid(x):
    result = []
    for i in range(len(x)):
        row_result = []
        for j in range(len(x[i])):
            row_result.append(x[i][j] * (1 - x[i][j]))
        result.append(row_result)
    return result



