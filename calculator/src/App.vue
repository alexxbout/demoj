<template>
    <div class="flex flex-col justify-between w-screen h-screen overflow-x-hidden p-5">
        <div class="w-full h-max flex flex-col gap-y-5">
            <div class="flex items-center justify-between">
                <button class="text-blue-600 font-medium text-lg w-max">Retour</button>

                <div class="w-10 h-10">
                    <img v-show="loading" class="w-full h-full aspect-square" src="./assets/spinner.svg" alt="" />
                </div>
            </div>
            <div class="rounded-xl w-full bg-gray-200 flex items-center justify-center overflow-hidden p-1">
                <button @click="mode = 'client'" :class="mode == 'client' ? 'bg-white text-black' : 'text-gray-500'" class="w-full py-2 px-5 rounded-lg text-center font-medium text-lg">Client</button>
                <button @click="mode = 'server'" :class="mode == 'server' ? 'bg-white text-black' : 'text-gray-500'" class="w-full py-2 px-5 rounded-lg text-center font-medium text-lg">Serveur</button>
            </div>
        </div>

        <div class="flex flex-col gap-y-5 w-full h-max">
            <select class="appearance-none w-full h-max rounded-xl bg-slate-200 px-5 py-4 text-lg font-medium" name="scenarioSelect" id="scenarioSelect">
                <option value="1">Fibonacci</option>
                <option value="2">Nombre premier</option>
                <option value="3">Factorielle</option>
            </select>
            <input @input="handleValueChange" v-model="valueInput" type="number" class="appearance-none w-full h-max rounded-xl bg-slate-200 px-5 py-4 text-lg font-medium" placeholder="Valeur..." />
            <button @click="handleExecute" class="bg-blue-600 text-white w-full h-max py-4 rounded-xl font-medium text-lg disabled:grayscale" :disabled="disabled">Exécuter</button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";

const router = useRouter();
const route = useRoute();

const mode = ref<"server" | "client">("client");

const valueInput = ref<string>();
const disabled = ref<boolean>(true);
const loading = ref<boolean>(false);

const handleExecute = () => {
    console.log("Execute");

    loading.value = true;

    setTimeout(() => {
        loading.value = false;
    }, 2000);
};

const handleValueChange = () => {
    disabled.value = valueInput.value === "";
};

onMounted(async () => {
    document.addEventListener("gesturestart", function (e) {
        e.preventDefault();
    });

    await router.isReady();

    mode.value = route.path.slice(1) as "server" | "client";
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
