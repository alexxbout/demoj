<template>
    <div class="flex flex-col w-screen h-full p-5 overflow-x-hidden justify-stretch">
        <div class="flex flex-col w-full h-max gap-y-5">
            <div class="flex items-center justify-between">
                <span class="text-4xl font-semibold dark:text-white">Calculatrice</span>

                <div class="w-10 h-10">
                    <img v-show="loading" class="w-full h-full aspect-square dark:invert" src="../assets/spinner.svg" alt="" />
                </div>
            </div>
            <div class="flex items-center justify-center w-full p-1 overflow-hidden bg-gray-200 rounded-xl">
                <button @click="mode = 'client'" :class="mode == 'client' ? 'bg-white text-black' : 'text-gray-500'" class="w-full px-5 py-2 text-lg font-medium text-center rounded-lg">Client</button>
                <button @click="mode = 'server'" :class="mode == 'server' ? 'bg-white text-black' : 'text-gray-500'" class="w-full px-5 py-2 text-lg font-medium text-center rounded-lg">Serveur</button>
            </div>
        </div>

        <div ref="field" class="w-screen px-5 overflow-x-auto scroll-smooth scrollbar-hide">
            <div class="flex items-center justify-end min-w-full px-5 pt-5 h-11 w-max">
                <span v-show="showPreviousFormula" class="absolute text-slate-400">{{ previousFormula }}</span>
            </div>
            <div class="flex items-center justify-end min-h-20 h-max min-w-full px-5 pb-5 w-max">
                <span class="text-6xl font-medium text-slate-700 dark:text-gray-200">{{ formula }}</span>
            </div>
        </div>

        <div class="grid grid-cols-4 gap-4">
            <Key @@click="clear" text="AC" type="action" :disabled="isKeyboardDisable" />
            <Key @@click="invertSign" text="+/-" type="action" :disabled="isKeyboardDisable" />
            <Key @@click="append('%')" text="%" type="action" :disabled="isKeyboardDisable" />
            <Key @@click="parenthese" text="( )" type="action" :disabled="isKeyboardDisable" />

            <Key @@click="fact" text="Fact" type="function" :disabled="isKeyboardDisable" />
            <Key @@click="fib" text="Fib" type="function" :disabled="isKeyboardDisable" />
            <Key @@click="prim" text="Prim" type="function" :disabled="isKeyboardDisable" />
            <Key @@click="append('/')" text="÷" type="operator" :disabled="isKeyboardDisable" />

            <Key @@click="append('7')" text="7" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('8')" text="8" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('9')" text="9" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('*')" text="x" type="operator" :disabled="isKeyboardDisable" />

            <Key @@click="append('4')" text="4" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('5')" text="5" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('6')" text="6" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('-')" text="-" type="operator" :disabled="isKeyboardDisable" />

            <Key @@click="append('1')" text="1" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('2')" text="2" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('3')" text="3" type="number" :disabled="isKeyboardDisable" />
            <Key @@click="append('+')" text="+" type="operator" :disabled="isKeyboardDisable" />

            <Key @@click="append('0')" text="0" type="number" :span="2" :disabled="isKeyboardDisable" />
            <Key @@click="append('.')" text="." type="number" :disabled="isKeyboardDisable" />
            <Key @@click="equal" text="=" type="operator" :disabled="isKeyboardDisable" />
        </div>
    </div>
</template>

<script setup lang="ts">
import axios, { AxiosResponse } from "axios";
import { onMounted, ref } from "vue";
import Key from "../components/Key.vue";
import * as compute from "../services/Compute.ts";

const field = ref<HTMLElement | null>(null);
const formula = ref("");
const previousFormula = ref("");
const showPreviousFormula = ref(false);
const nbOpenParentheses = ref(0);
const clearAfter = ref(false);
const isKeyboardDisable = ref(false);

const mode = ref<"server" | "client">("client");

const loading = ref<boolean>(false);

const escapeDivOperator = (value: string) => {
    return value.replace(/\//g, "div");
};

const clear = () => {
    formula.value = "";
    nbOpenParentheses.value = 0;
    showPreviousFormula.value = false;
};

const invertSign = () => {
    formula.value = formula.value.startsWith("-") ? formula.value.slice(1) : `-${formula.value}`;
};

const append = (value: string) => {
    if (clearAfter.value) {
        clear();
        clearAfter.value = false;
    }

    if (formula.value === "0" && value === "0") {
        return;
    }

    if (formula.value === "0" && value !== ".") {
        formula.value = value;
    } else {
        formula.value += value;
    }

    setTimeout(scrollToRight, 1);
};

const scrollToRight = () => {
    if (field.value) field.value.scrollLeft = field.value.scrollWidth;
};

const scrollToLeft = () => {
    if (field.value) field.value.scrollLeft = 0;
};

const equal = async () => {
    loading.value = true;

    isKeyboardDisable.value = true;

    // If there are unclosed parentheses, close them
    for (let i = 0; i < nbOpenParentheses.value; i++) {
        formula.value += ")";
    }

    showPreviousFormula.value = false;
    previousFormula.value = formula.value;

    clearAfter.value = true;

    if (mode.value == "server") {
        // On the server side, we only need to send the formula to the server
        await axios.get(`/api/scenarios/calculator/${escapeDivOperator(formula.value)}`).then((response: AxiosResponse<{ result: string }>) => {
            formula.value = response.data.result;
        });

        endExec();
    } else {
        // On the client side, we need to parse the formula and execute functions
        if (typeof Worker !== "undefined") {
            const worker = new Worker(new URL("../services/CalculatorWorker.ts", import.meta.url), { type: "module" });

            worker.onmessage = (event) => {
                formula.value = event.data;
                endExec();
            };

            worker.postMessage({ expression: formula.value });
        } else {
            formula.value = compute.parseAndEvaluate(formula.value);
            endExec();
        }
    }
};

const endExec = () => {
    setTimeout(scrollToLeft, 1);

    showPreviousFormula.value = true;

    isKeyboardDisable.value = false;

    loading.value = false;
};

const parenthese = () => {
    if (nbOpenParentheses.value === 0) {
        nbOpenParentheses.value++;
        formula.value += "(";
    } else {
        const lastChar = formula.value.slice(-1);
        const operators = ["+", "-", "*", "/"];
        if (operators.includes(lastChar) || lastChar === "(") {
            formula.value += "(";
            nbOpenParentheses.value++;
        } else {
            nbOpenParentheses.value--;
            formula.value += ")";
        }
    }
};

const fact = () => {
    append("fact(");
    nbOpenParentheses.value++;
};

const fib = () => {
    append("fib(");
    nbOpenParentheses.value++;
};

const prim = () => {
    append("prim(");
    nbOpenParentheses.value++;
};

onMounted(() => {
    console.log("Calculator mounted");
});
</script>
