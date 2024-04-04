<template>
    <div class="flex flex-col gap-y-5 w-full h-max">
        <select v-model="valueSelect" class="appearance-none w-full h-max rounded-xl bg-slate-200 px-5 py-4 text-lg font-medium" name="scenarioSelect" id="scenarioSelect">
            <option value="1">Factorielle</option>
            <option value="2" disabled>Nombre premier</option>
            <option value="3" disabled>Fibonacci</option>
        </select>
        <input @input="handleValueChange" v-model="valueInput" type="number" class="appearance-none w-full h-max rounded-xl bg-slate-200 px-5 py-4 text-lg font-medium" placeholder="Valeur..." />
        <button @click="handleExecute" class="bg-blue-600 text-white w-full h-max py-4 rounded-xl font-medium text-lg disabled:grayscale" :disabled="disabled">Exécuter</button>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue";

const valueInput = ref<string>("");
const valueSelect = ref<string>("1");
const disabled = ref<boolean>(true);

const emits = defineEmits<{
    (e: "@execute", mode: string, value: string): void;
}>();

const handleExecute = () => {
    emits("@execute", valueSelect.value, valueInput.value);
};

const handleValueChange = () => {
    disabled.value = valueInput.value === "";
};
</script>
