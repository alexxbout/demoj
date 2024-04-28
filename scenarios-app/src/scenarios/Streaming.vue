<template>
    <div class="flex flex-col w-screen h-[100svh] p-5 overflow-x-hidden justify-between">
        <span class="text-4xl font-semibold dark:text-white">Streaming</span>

        <div class="w-full my-20">
            <video v-if="url.length > 0" class="w-full shadow-2xl rounded-xl" width="100%" height="100%" preload= "auto" controls muted autoplay loop playsinline>
                <source :src="url" type="video/webm" />
            </video>
        </div>

        <div class="flex flex-col w-full gap-y-5 h-max">
            <select v-model="selected" class="w-full px-5 py-4 text-lg font-medium appearance-none h-max rounded-xl bg-slate-200" name="scenarioSelect" id="scenarioSelect" placeholder="Choisir une option...">
                <option value="" disabled selected>Choisir une option...</option>
                <option v-for="option in options" :value="option.value">{{ option.text }}</option>
            </select>
            <button @click="handleExecute" class="w-full py-4 text-lg font-medium text-white bg-blue-600 h-max rounded-xl disabled:grayscale" :disabled="disabled">Charger la vidéo</button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from "vue";

const base = `http://${import.meta.env.VITE_API_ENDPOINT}`;

const options = ref<{ value: string; text: string }[]>([
    {
        value: "480",
        text: "Vidéo basse qualité",
    },
    {
        value: "1080",
        text: "Vidéo haute qualité",
    },
    {
        value: "4k",
        text: "Vidéo très haute qualité",
    },
]);

const selected = ref<string>("");

const disabled = computed(() => !selected.value);

const url = ref<string>("");

const handleExecute = async () => {
    console.log("Loading video with quality: ", selected.value);

    url.value = "";

    await nextTick();

    url.value = base + ":5000" + "/static/" + selected.value + ".webm";
};

onMounted(() => {
    console.log("Streaming mounted");
});
</script>
