export const fib = (n: number): number => {
    if (n <= 0) return 0;
    if (n === 1) return 1;
    return fib(n - 1) + fib(n - 2);
};

export const fact = (n: number): number => {
    if (n === 0) return 1;
    return n * fact(n - 1);
};

export const prime = (n: number): boolean => {
    if (n <= 1) return false;
    for (let i = 2; i <= Math.sqrt(n); i++) {
        if (n % i === 0) return false;
    }
    return true;
};

export const parseAndEvaluate = (expression: string): string => {
    let result: string = "";
    let containsPrimeFunction = false;

    try {
        // Replace function calls with their values
        expression = expression.replace(/fib\((\d+)\)/g, (_, n) => fib(parseInt(n)).toString());
        expression = expression.replace(/fact\((\d+)\)/g, (_, n) => fact(parseInt(n)).toString());

        // Check if the expression contains a call to the prime function
        if (expression.includes("prim")) {
            containsPrimeFunction = true;
            expression = expression.replace(/prim\((\d+)\)/g, (_, n) => (prime(parseInt(n)) ? "Vrai" : "Faux"));
        }

        // Evaluate the expression with basic operators using eval only if it doesn't contain a call to the prime function
        if (!containsPrimeFunction) {
            result = eval(expression).toString();
        } else {
            result = expression;
        }
    } catch (error) {
        console.error("Error while parsing or evaluating the expression:", error);
        result = ":(";
    }

    return result;
};
