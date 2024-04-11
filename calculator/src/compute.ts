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
