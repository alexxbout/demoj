<template>
    <div class="flex flex-col w-screen h-screen overflow-x-hidden">
        <div class="mt-auto"></div>

        <div ref="field" class="w-screen p-5 overflow-x-auto scroll-smooth scrollbar-hide">
            <div class="flex items-center justify-end h-24 min-w-full p-5 ml-auto w-max bg-stone-200 rounded-3xl">
                <span class="text-5xl font-semibold">{{ formula }}</span>
            </div>
        </div>

        <div class="grid grid-cols-4 gap-5 p-5">
            <Key @@click="clear" text="AC" type="ac" :span="2" />
            <Key @@click="deleteChar" type="delete" :span="2" />

            <Key @@click="append('(')" text="(" type="operator" />
            <Key @@click="append(')')" text=")" type="operator" />
            <Key @@click="append('^')" text="^" type="operator" />
            <Key @@click="operator('/')" text="/" type="operator" />

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

            <Key @@click="append('.')" text="." type="number" />
            <Key @@click="append('0')" text="0" type="number" />
            <Key @@click="equal" text="=" type="equal" :span="2" />
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import Key from "./components/Key.vue";

const field = ref<HTMLElement | null>(null);
const formula = ref("");

const clear = () => {
    formula.value = "";
};

const deleteChar = () => {
    formula.value = formula.value.slice(0, -1);
};

const append = (value: string) => {
    if (formula.value.endsWith(".") && value === "0") {
        return;
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
    if (field.value) {
        field.value.scrollLeft = field.value.scrollWidth;
    }
};

const operator = (op: string) => {
    formula.value += op;
};

const equal = () => {
    try {
        // Replace ^ with **
        const evaluatedFormula = formula.value.replace(/\^/g, "**");
        // Evaluate the modified formula
        formula.value = eval(evaluatedFormula).toString();
    } catch (error) {
        formula.value = ":(";
    }

    if (field.value) {
        field.value.scrollLeft = 0;
    }
};
</script>

<style scoped>
/* For Webkit-based browsers (Chrome, Safari and Opera) */
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}

/* For IE, Edge and Firefox */
.scrollbar-hide {
    -ms-overflow-style: none; /* IE and Edge */
    scrollbar-width: none; /* Firefox */
}
</style>
