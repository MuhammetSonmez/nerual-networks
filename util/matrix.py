import util.mat as mat

def get_dim(matrix):
    return [len(matrix), len(matrix[0])]    

def mean(matrix):
    temp = [matrix[i][j] for j in range(len(matrix[0])) for i in range(len(matrix))]
    return sum(temp)/(len(matrix[0] * len(matrix)))

def multiple(matrix1, matrix2):
    result = []
    if len(matrix1[0]) != len(matrix2):
        print(f"{matrix1}\n{matrix2}")
        raise ValueError("Check your matrix dims")
    rows = len(matrix1)
    cols = len(matrix2[0])

    for i in range(rows):
        row = []
        for j in range(cols):
            element_sum = 0
            for k in range(len(matrix1[0])):
                element_sum += matrix1[i][k] * matrix2[k][j]
            row.append(element_sum)
        result.append(row)
    return result

def add(matrix1, matrix2):
    row_count = len(matrix1)
    col_count = len(matrix1[0])
    
    if len(matrix2) != row_count or len(matrix2[0]) != col_count:
        print(matrix1, matrix2)
        raise ValueError("Check your matrix dims")
    
    total_matrix = [[0] * col_count for _ in range(row_count)]
    
    for i in range(row_count):
        for j in range(col_count):
            total_matrix[i][j] = matrix1[i][j] + matrix2[i][j]
    
    return total_matrix

def get_diagon(matrix):
    result = []
    for i in range(len(matrix)):
        row = []
        for j in range(len(matrix[0])):
            if i == j:
                row.append(matrix[i][j])
        result.append(row)
    return result

def add_number(matrix, n):
    result = []
    for i in range(len(matrix)):
        row = []
        for j in range(len(matrix[0])):
            row.append(matrix[i][j] + n)
        result.append(row)
    return result

def generate_I(n):
    I = [[0] * n for _ in range(n)]
    for i in range(n):
        I[i][i] = 1
    return I


def divide(matrix, d):
    result = []
    for i in range(len(matrix)):
        row = []
        for j in range(len(matrix[0])):
            row.append(d/matrix[i][j])
        result.append(row)
    return result

def negative(matrix):
    result = []
    for i in range(len(matrix)):
        row = []
        for j in range(len(matrix[0])):
            row.append(-1* matrix[i][j])
        result.append(row)
    return result


def transpose(matrix):
    result = []
    for i in range(len(matrix[0])):
        row = []
        for j in range(len(matrix)):
            row.append(matrix[j][i])
        result.append(row)
    return result


def exp(matrix):
    result = []
    for i in range(len(matrix)):
        row = []
        for j in range(len(matrix[0])):
            row.append(mat.eexp(matrix[i][j]))
        result.append(row)
    return result

