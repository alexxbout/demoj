<template>
    <div class="flex flex-col justify-between w-screen h-screen px-5 py-5 overflow-x-hidden">
        <div class="flex flex-col w-full h-max gap-y-5">
            <div class="flex items-center justify-between">
                <!-- <button class="text-lg font-medium text-blue-600 w-max">Retour</button> -->

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

        <Functions v-if="appMode == 'functions'" @@execute="handleFuncExec" />
        <Calculator ref="calculator" :result="result" v-else @@execute="handleCalcExec" />
    </div>
</template>

<script setup lang="ts">
import axios, { AxiosResponse } from "axios";
import { onMounted, ref } from "vue";
import Calculator from "./components/Calculator.vue";
import Functions from "./components/Functions.vue";

const communicationMode = ref<"server" | "client">("client");
const appMode = ref<"calculator" | "functions">("calculator");

const calculator = ref<InstanceType<typeof Calculator> | null>(null);

// Variable used to store standard calcul
const result = ref("");

const loading = ref<boolean>(false);

const handleFuncExec = (_mode: string, _value: string) => {
    loading.value = true;

    // TODO: Implement the server-side logic

    setTimeout(() => {
        loading.value = false;
    }, 2000);
};

const handleCalcExec = async (value: string) => {
    if (calculator.value) {
        if (communicationMode.value == "client") {
            calculator.value.setResult(performCalculation(value));
        } else {
            loading.value = true;
            // TODO: Send the calculation to the server
            // using axios, import from .env VITE_API_ENDPOINT and call IP/api/scenarios/calculator/<mode>/<value>

            await axios.get(`/api/scenarios/calculator/standard/${value}`).then((response: AxiosResponse<{ result: string }>) => {
                calculator.value?.setResult(response.data.result);
            });

            loading.value = false;
        }
    }
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
