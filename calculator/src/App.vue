<template>
    <div class="flex flex-col w-screen h-screen px-5 py-5 overflow-x-hidden justify-stretch">
        <div class="flex flex-col w-full h-max gap-y-5">
            <div class="flex items-center justify-between">
                <span class="text-4xl font-semibold">Calculatrice</span>

                <div class="w-10 h-10">
                    <img v-show="loading" class="w-full h-full aspect-square" src="./assets/spinner.svg" alt="" />
                </div>
            </div>
            <div class="flex items-center justify-center w-full p-1 overflow-hidden bg-gray-200 rounded-xl">
                <button @click="communicationMode = 'client'" :class="communicationMode == 'client' ? 'bg-white text-black' : 'text-gray-500'" class="w-full px-5 py-2 text-lg font-medium text-center rounded-lg">Client</button>
                <button @click="communicationMode = 'server'" :class="communicationMode == 'server' ? 'bg-white text-black' : 'text-gray-500'" class="w-full px-5 py-2 text-lg font-medium text-center rounded-lg">Serveur</button>
            </div>
            <div class="flex items-center justify-center w-full p-1 overflow-hidden bg-gray-200 rounded-xl">
                <button @click="appMode = 'calculator'" :class="appMode == 'calculator' ? 'bg-white text-black' : 'text-gray-500'" class="w-full px-5 py-2 text-lg font-medium text-center rounded-lg">Standard</button>
                <button @click="appMode = 'functions'" :class="appMode == 'functions' ? 'bg-white text-black' : 'text-gray-500'" class="w-full px-5 py-2 text-lg font-medium text-center rounded-lg">Fonctions</button>
            </div>
        </div>

        <Functions v-if="appMode == 'functions'" @@execute="handleFuncExec" ref="functions" :result="result" />
        <Calculator v-else @@execute="handleCalcExec" ref="calculator" :result="result" />
    </div>
</template>

<script setup lang="ts">
import axios, { AxiosResponse } from "axios";
import { onMounted, ref } from "vue";
import Calculator from "./components/Calculator.vue";
import Functions from "./components/Functions.vue";
import * as compute from "./compute.ts";
import { FuncTypes } from "./types";

const communicationMode = ref<"server" | "client">("client");
const appMode = ref<"calculator" | "functions">("calculator");

const calculator = ref<InstanceType<typeof Calculator> | null>(null);
const functions = ref<InstanceType<typeof Functions> | null>(null);

// Variable used to store standard calcul
const result = ref("");

const loading = ref<boolean>(false);

const escapeDivOperator = (value: string) => {
    return value.replace(/\//g, 'div');
};

const handleFuncExec = async (mode: FuncTypes, value: string) => {
    loading.value = true;

    if (functions.value) {
        if (communicationMode.value == "client") {
            const n = parseInt(value);
            switch (mode) {
                case FuncTypes.FACTORIAL:
                    functions.value.setResult(compute.fact(n).toString());
                    break;
                case FuncTypes.PRIME:
                    functions.value.setResult(compute.prime(n) ? "Vrai" : "Faux");
                    break;
                case FuncTypes.FIBONACCI:
                    functions.value.setResult(compute.fib(n).toString());
                    break;
            }
        } else {
            value = escapeDivOperator(value); // Escape the division operator
            await axios.get(`/api/scenarios/calculator/${mode}/${value}`).then((response: AxiosResponse<{ result: string }>) => {
                functions.value?.setResult(response.data.result);
            });
        }
    }

    loading.value = false;
};

const handleCalcExec = async (value: string) => {
    loading.value = true;

    if (calculator.value) {
        if (communicationMode.value == "client") {
            calculator.value.setResult(performCalculation(value));
        } else {
            value = escapeDivOperator(value); // Escape the division operator
            await axios.get(`/api/scenarios/calculator/standard/${value}`).then((response: AxiosResponse<{ result: string }>) => {
                calculator.value?.setResult(response.data.result);
            });
        }
    }
    loading.value = false;
};

const performCalculation = (value: string) => {
    try {
        return eval(value);
    } catch (e) {
        return ":(";
    }
};

onMounted(() => {
    // Prevent pinch zoom
    document.addEventListener("gesturestart", (e) => e.preventDefault());
});
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
