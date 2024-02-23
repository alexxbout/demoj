
class ArithmeticExpressionEvaluator {
    static INVALID_NUMBER = -1234567.654;
    private str: string;
    private pos: number;
    private ch: string;

    constructor() {
        this.str = "";
        this.pos = -1;
        this.ch = "";
    }

    evaluate(expression: string): number {
        return this.evaluateAll(expression, false);
    }

    evaluateAll(expression: string, resultIsInteger: boolean): number {
        this.str = expression;
        this.pos = -1;
        const outcome = this.parse();
        if (resultIsInteger) {
            return Math.round(outcome);
        }
        return outcome;
    }

    nextChar() {
        this.ch = ++this.pos < this.str.length ? this.str.charAt(this.pos) : "";
    }

    eat(charToEat: string): boolean {
        while (this.ch === " ") {
            this.nextChar();
        }
        if (this.ch === charToEat) {
            this.nextChar();
            return true;
        }
        return false;
    }

    parse(): number {
        this.nextChar();
        const x = this.parseExpression();
        if (this.pos < this.str.length) {
            return ArithmeticExpressionEvaluator.INVALID_NUMBER;
        }
        return x;
    }

    parseExpression(): number {
        let x = this.parseTerm();
        for (;;) {
            if (this.eat("+")) {
                // addition
                x += this.parseTerm();
                // x = addition(x, this.parseTerm());
            } else if (this.eat("-")) {
                // subtraction
                x -= this.parseTerm();
                // x = subtraction(x, this.parseTerm());
            } else {
                return x;
            }
        }
    }

    parseTerm(): number {
        let x = this.parseFactor();
        for (;;) {
            if (this.eat("*")) {
                // multiplication
                x *= this.parseFactor();
                // x = multiplication(x, this.parseFactor());
            } else if (this.eat("/")) {
                // division
                x /= this.parseFactor();
                // x = division(x, this.parseFactor());
            } else {
                return x;
            }
        }
    }

    parseFactor(): number {
        if (this.eat("+")) {
            // unary plus
            return this.parseFactor();
        }
        if (this.eat("-")) {
            // unary minus
            return -this.parseFactor();
        }
        let x;
        const startPos = this.pos;
        if (this.eat("(")) {
            // parentheses
            x = this.parseExpression();
            this.eat(")");
        } else if ((this.ch >= "0" && this.ch <= "9") || this.ch === ".") {
            // numbers
            while ((this.ch >= "0" && this.ch <= "9") || this.ch === ".") {
                this.nextChar();
            }
            x = parseFloat(this.str.substring(startPos, this.pos));
        } else if (this.ch >= "a" && this.ch <= "z") {
            // functions
            while (this.ch >= "a" && this.ch <= "z") {
                this.nextChar();
            }
            const func = this.str.substring(startPos, this.pos);
            x = this.parseFactor();
            if (func === "sqrt") {
                x = Math.sqrt(x);
            } else if (func === "sin") {
                x = Math.sin(this.degreesToRadians(x));
            } else if (func === "cos") {
                x = Math.cos(this.degreesToRadians(x));
            } else if (func === "tan") {
                x = Math.tan(this.degreesToRadians(x));
            } else {
                return ArithmeticExpressionEvaluator.INVALID_NUMBER;
            }
        } else {
            return ArithmeticExpressionEvaluator.INVALID_NUMBER;
        }
        if (this.eat("^")) {
            // exponentiation
            x = Math.pow(x, this.parseFactor());
        }
        return x;
    }

    degreesToRadians(degrees: number): number {
        const pi = Math.PI;
        return degrees * (pi / 180);
    }
}

export default new ArithmeticExpressionEvaluator();