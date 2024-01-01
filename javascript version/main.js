function eexp(x, terms = 10) {
    let result = 1.0;
    let factorial = 1.0;

    for (let i = 1; i <= terms; i++) {
        factorial *= i;
        result += (x ** i) / factorial;
    }

    return result;
}

let e = eexp(1);


// sigmoid
function sigmoid(x) {
    return 1 / (1 + Math.exp(-1 * x));
}

function derivedSigmoid(x) {
    let result = [];
    for (let i = 0; i < x.length; i++) {
        let rowResult = [];
        for (let j = 0; j < x[i].length; j++) {
            rowResult.push(x[i][j] * (1 - x[i][j]));
        }
        result.push(rowResult);
    }
    return result;
}

function getDim(matrix) {
    return [matrix.length, matrix[0].length];
}

function mean(matrix) {
    let temp = [];
    for (let j = 0; j < matrix[0].length; j++) {
        for (let i = 0; i < matrix.length; i++) {
            temp.push(matrix[i][j]);
        }
    }
    return temp.reduce((acc, val) => acc + val, 0) / (matrix[0].length * matrix.length);
}

function multiply(matrix1, matrix2) {
    let result = [];
    /*
    if (matrix1[0].length !== matrix2.length) {
        console.log(`${matrix1}\n${matrix2}`);
        throw new Error("Check your matrix dims");
    }
    */
    let rows = matrix1.length;
    let cols = matrix2[0].length;

    for (let i = 0; i < rows; i++) {
        let row = [];
        for (let j = 0; j < cols; j++) {
            let elementSum = 0;
            for (let k = 0; k < matrix1[0].length; k++) {
                elementSum += matrix1[i][k] * matrix2[k][j];
            }
            row.push(elementSum);
        }
        result.push(row);
    }
    return result;
}

function add(matrix1, matrix2) {
    let rowCount = matrix1.length;
    let colCount = matrix1[0].length;

    if (matrix2.length !== rowCount || matrix2[0].length !== colCount) {
        console.log(matrix1, matrix2);
        throw new Error("Check your matrix dims");
    }

    let totalMatrix = Array.from({ length: rowCount }, () => Array(colCount).fill(0));

    for (let i = 0; i < rowCount; i++) {
        for (let j = 0; j < colCount; j++) {
            totalMatrix[i][j] = matrix1[i][j] + matrix2[i][j];
        }
    }

    return totalMatrix;
}

function getDiagonal(matrix) {
    let result = [];
    for (let i = 0; i < matrix.length; i++) {
        let row = [];
        for (let j = 0; j < matrix[0].length; j++) {
            if (i === j) {
                row.push(matrix[i][j]);
            }
        }
        result.push(row);
    }
    return result;
}

function addNumber(matrix, n) {
    let result = [];
    for (let i = 0; i < matrix.length; i++) {
        let row = [];
        for (let j = 0; j < matrix[0].length; j++) {
            row.push(matrix[i][j] + n);
        }
        result.push(row);
    }
    return result;
}

function generateI(n) {
    let I = Array.from({ length: n }, () => Array(n).fill(0));
    for (let i = 0; i < n; i++) {
        I[i][i] = 1;
    }
    return I;
}

function divide(matrix, d) {
    let result = [];
    for (let i = 0; i < matrix.length; i++) {
        let row = [];
        for (let j = 0; j < matrix[0].length; j++) {
            row.push(d / matrix[i][j]);
        }
        result.push(row);
    }
    return result;
}

function negative(matrix) {
    let result = [];
    for (let i = 0; i < matrix.length; i++) {
        let row = [];
        for (let j = 0; j < matrix[0].length; j++) {
            row.push(-1 * matrix[i][j]);
        }
        result.push(row);
    }
    return result;
}

function transpose(matrix) {
    let result = [];
    for (let i = 0; i < matrix[0].length; i++) {
        let row = [];
        for (let j = 0; j < matrix.length; j++) {
            row.push(matrix[j][i]);
        }
        result.push(row);
    }
    return result;
}

function exp(matrix) {
    let result = [];
    for (let i = 0; i < matrix.length; i++) {
        let row = [];
        for (let j = 0; j < matrix[0].length; j++) {
            row.push(Math.exp(matrix[i][j]));
        }
        result.push(row);
    }
    return result;
}

// main script
// data
var x_input = [[0, 0, 1], [1, 1, 1], [1, 0, 0]];
var y_output = transpose([[0, 1, 1]]);

// training
function training(step) {
    var history = [];
    var weight = transpose([[1, 1, 1]]); // random values
    for (var i = 0; i < step; i++) {
        var node_value = multiply(x_input, weight);
        var predict = divide(addNumber(exp(negative(node_value)), 1), 1); // sigmoid function
        var d = derivedSigmoid(transpose(predict));
        var error = add(y_output, negative(predict));
        weight = add(weight, multiply(transpose(x_input), getDiagonal(multiply(error, d))));
        // console.log(Math.abs(mean(error)));
        history.push(Math.abs(mean(error)));
    }
    return weight;//,history;
}

function ask(my_input, weight) {
    var output = divide(addNumber(exp(negative(multiply(my_input, weight))), 1), 1);
    return output;
}


var weight= training(300);

var result = ask([[1, 0, 0]], weight);
console.log("rounded result: ", Math.round(result[0][0]));
console.log("result: ", result[0]);

alert("rounded result: "+ Math.round(result[0][0]) + "\nresult: " + result[0]);
