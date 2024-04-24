<template>
    <div class="flex flex-col w-screen h-screen p-5 overflow-x-hidden justify-stretch">
        <div class="flex flex-col w-full h-max gap-y-5">
            <div class="flex items-center justify-between">
                <span class="text-4xl font-semibold dark:text-white">Streaming</span>

                <div class="w-10 h-10">
                    <img v-show="loading" class="w-full h-full aspect-square dark:invert" src="../assets/spinner.svg" alt="" />
                </div>
            </div>
        </div>

    </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";

const loading = ref(false);

onMounted(() => {
    console.log("Streaming mounted");
});
</script>
