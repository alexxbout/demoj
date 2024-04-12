<template>
    <div ref="field" class="w-screen p-5 overflow-x-auto scroll-smooth scrollbar-hide">
        <div class="flex items-center justify-end h-24 min-w-full p-5 ml-auto w-max">
            <span class="text-6xl font-medium text-slate-700">{{ formula }}</span>
        </div>
    </div>

    <div class="grid grid-cols-4 gap-4">
        <Key @@click="fact" text="Fact" type="action" />
        <Key @@click="fib" text="Fib" type="action" />
        <Key @@click="prim" text="Prim" type="action" />
        <Key @@click="parenthese" text="( )" type="action" />

        <Key @@click="clear" text="AC" type="action" />
        <Key @@click="invertSign" text="+/-" type="action" />
        <Key @@click="append('%')" text="%" type="action" />
        <Key @@click="append('/')" text="÷" type="operator" />

        <Key @@click="append('7')" text="7" type="number" />
        <Key @@click="append('8')" text="8" type="number" />
        <Key @@click="append('9')" text="9" type="number" />
        <Key @@click="operator('*')" text="x" type="operator" />

        <Key @@click="append('4')" text="4" type="number" />
        <Key @@click="append('5')" text="5" type="number" />
        <Key @@click="append('6')" text="6" type="number" />
        <Key @@click="operator('-')" text="-" type="operator" />

        <Key @@click="append('1')" text="1" type="number" />
        <Key @@click="append('2')" text="2" type="number" />
        <Key @@click="append('3')" text="3" type="number" />
        <Key @@click="operator('+')" text="+" type="operator" />

        <Key @@click="append('0')" text="0" type="number" :span="2" />
        <Key @@click="append('.')" text="." type="number" />
        <Key @@click="equal" text="=" type="operator" />
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import Key from "./Key.vue";

const emits = defineEmits<{
    (e: "@execute", value: string): void;
}>();

const field = ref<HTMLElement | null>(null);
const formula = ref("");
const nbOpenParentheses = ref(0);

const clear = () => {
    formula.value = "";
};

const invertSign = () => {
    formula.value = formula.value.startsWith("-") ? formula.value.slice(1) : `-${formula.value}`;
};

const append = (value: string) => {
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
    if (field.value) {
        field.value.scrollLeft = field.value.scrollWidth;
    }
};

const scrollToLeft = () => {
    if (field.value) {
        field.value.scrollLeft = 0;
    }
};

const operator = (op: string) => {
    formula.value += op;
};

const equal = () => {
    emits("@execute", formula.value);

    if (field.value) {
        setTimeout(scrollToLeft, 1);
    }
};

const setResult = (value: string) => {
    formula.value = value;
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
    formula.value += "fact(";
    nbOpenParentheses.value++;
};

const fib = () => {
    formula.value += "fib(";
    nbOpenParentheses.value++;
};

const prim = () => {
    formula.value += "prim(";
    nbOpenParentheses.value++;
};

defineExpose({
    setResult,
});
</script>
