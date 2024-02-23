import ArithmeticExpressionEvaluator from "./ArithmeticExpressionEvaluator";

export function addition(a: number, b: number): number {
    // Addition de deux nombres, procédant chiffre par chiffre
    const result: number[] = [];
    let carry = 0;
    let i = 1;
    let j = 1;
    while (a / i >= 1 || b / j >= 1 || carry !== 0) {
        const sum = (Math.floor(a / i) % 10) + (Math.floor(b / j) % 10) + carry;
        carry = Math.floor(sum / 10);
        result.unshift(sum % 10);
        i *= 10;
        j *= 10;
    }
    return parseFloat(result.join(""));
}

export function subtraction(a: number, b: number): number {
    return a - b;
}

export function multiplication(a: number, b: number): number {
    // Multiplication de deux nombres, tenant compte des décimales
    const aDecimals = getDecimalCount(a);
    const bDecimals = getDecimalCount(b);
    const multiplier = Math.pow(10, aDecimals + bDecimals);
    const result = a * b * multiplier;
    return result / multiplier;
}

function getDecimalCount(num: number): number {
    // Renvoie le nombre de décimales dans un nombre
    const decimals = num.toString().split('.')[1];
    return decimals ? decimals.length : 0;
}

export function division(a: number, b: number): number {
    // Division de deux nombres, procédant chiffre par chiffre
    if (b === 0) {
        throw new Error("Division par zéro.");
    }
    let quotient = 0;
    let remainder = Math.abs(a);
    let divisor = Math.abs(b);
    while (remainder >= divisor) {
        remainder = subtraction(remainder, divisor);
        quotient++;
    }
    if ((a < 0 && b > 0) || (a > 0 && b < 0)) {
        return -quotient;
    } else {
        return quotient;
    }
}

export function generateRandomExpression(): string {
    const operators = ["+", "-", "*", "/"];
    const numOperations = Math.floor(Math.random() * 5) + 1; // Entre 1 et 5 opérations
    let expression = "";

    for (let i = 0; i < numOperations; i++) {
        if (i > 0) {
            expression += operators[Math.floor(Math.random() * operators.length)];
        }
        const number = (Math.random() * 100).toFixed(2); // Nombre aléatoire entre 0 et 100 avec 2 décimales
        if (Math.random() < 0.5) {
            expression += number;
        } else {
            expression += `-${number}`;
        }
    }

    return expression;
}

export function testCalculateFunction(nb: number) {
    let passed = true;

    for (let i = 0; i < nb; i++) {
        const expression = generateRandomExpression();

        try {
            const expected = eval(expression); // Calculer le résultat attendu avec eval (pour comparer)

            const result = ArithmeticExpressionEvaluator.evaluate(expression);
            if (result !== expected) {
                console.log(`Erreur: Expression "${expression}" a donné ${result}, mais ${expected} était attendu.`);
                passed = false;
            } else {
                console.log(`Test réussi: Expression "${expression}" a donné ${result}`);
            }
        } catch (error: any) {
            console.log(`Erreur: Expression "${expression}" a provoqué une erreur: ${error.message}`);
            passed = false;
        }
    }

    if (passed) {
        console.log("Tous les tests ont réussi !");
    } else {
        console.log("Certains tests ont échoué.");
    }
}
