<template>
    <div class="flex flex-col justify-between w-screen h-screen overflow-x-hidden py-5 px-5">
        <div class="w-full h-max flex flex-col gap-y-5">
            <div class="flex items-center justify-between">
                <!-- <button class="text-blue-600 font-medium text-lg w-max">Retour</button> -->

                <span class="font-semibold text-4xl">Calculatrice</span>

                <div class="w-10 h-10">
                    <img v-show="loading" class="w-full h-full aspect-square" src="./assets/spinner.svg" alt="" />
                </div>
            </div>
            <div class="rounded-xl w-full bg-gray-200 flex items-center justify-center overflow-hidden p-1">
                <button @click="communicationMode = 'client'" :class="communicationMode == 'client' ? 'bg-white text-black' : 'text-gray-500'" class="w-full py-2 px-5 rounded-lg text-center font-medium text-lg">Client</button>
                <button @click="communicationMode = 'server'" :class="communicationMode == 'server' ? 'bg-white text-black' : 'text-gray-500'" class="w-full py-2 px-5 rounded-lg text-center font-medium text-lg">Serveur</button>
            </div>
            <div class="rounded-xl w-full bg-gray-200 flex items-center justify-center overflow-hidden p-1">
                <button @click="appMode = 'calculator'" :class="appMode == 'calculator' ? 'bg-white text-black' : 'text-gray-500'" class="w-full py-2 px-5 rounded-lg text-center font-medium text-lg">Standard</button>
                <button @click="appMode = 'functions'" :class="appMode == 'functions' ? 'bg-white text-black' : 'text-gray-500'" class="w-full py-2 px-5 rounded-lg text-center font-medium text-lg">Fonctions</button>
            </div>
        </div>

        <Functions v-if="appMode == 'functions'" @@execute="handleFuncExec" />
        <Calculator ref="calculator" :result="result" v-else @@execute="handleCalcExec" />
    </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import Calculator from "./components/Calculator.vue";
import Functions from "./components/Functions.vue";

const communicationMode = ref<"server" | "client">("client");
const appMode = ref<"calculator" | "functions">("calculator");

const calculator = ref<InstanceType<typeof Calculator> | null>(null);

// Variable used to store standard calcul
const result = ref("");

const loading = ref<boolean>(false);

const handleFuncExec = (mode: string, value: string) => {
    loading.value = true;

    // TODO: Implement the server-side logic

    setTimeout(() => {
        loading.value = false;
    }, 2000);
};

const handleCalcExec = (value: string) => {
    if (communicationMode.value == "client" && calculator.value) {
        calculator.value.setResult(performCalculation(value));
    } else {
        loading.value = true;
        // TODO: Send the calculation to the server
        setTimeout(() => {
            loading.value = false;
        }, 2000);
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
