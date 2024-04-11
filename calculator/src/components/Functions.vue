<template>
    <div class="flex flex-col w-full gap-y-5 h-max">
        <div ref="field" class="w-screen p-5 overflow-x-auto scroll-smooth scrollbar-hide">
            <div class="flex items-center justify-end h-24 min-w-full p-5 ml-auto w-max">
                <span class="text-6xl font-medium text-slate-700">{{ formula }}</span>
            </div>
        </div>

        <select v-model="valueSelect" class="w-full px-5 py-4 text-lg font-medium appearance-none h-max rounded-xl bg-slate-200" name="scenarioSelect" id="scenarioSelect">
            <option :value="FuncTypes.FACTORIAL">Factorielle</option>
            <option :value="FuncTypes.FIBONACCI">Fibonacci</option>
            <option :value="FuncTypes.PRIME">Nombre premier</option>
        </select>
        <input @input="handleValueChange" v-model="valueInput" type="number" class="w-full px-5 py-4 text-lg font-medium appearance-none h-max rounded-xl bg-slate-200" placeholder="Valeur..." />
        <button @click="handleExecute" class="w-full py-4 text-lg font-medium text-white bg-blue-600 h-max rounded-xl disabled:grayscale" :disabled="disabled">Exécuter</button>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { FuncTypes } from "../types";

const valueInput = ref<string>("");
const valueSelect = ref<FuncTypes>(FuncTypes.FACTORIAL);
const disabled = ref<boolean>(true);
const formula = ref("");

const emits = defineEmits<{
    (e: "@execute", mode: FuncTypes, value: string): void;
}>();

const handleExecute = () => {
    emits("@execute", valueSelect.value, valueInput.value);
};

const handleValueChange = () => {
    disabled.value = valueInput.value === "";
};

const setResult = (value: string) => {
    formula.value = value;
};

defineExpose({
    setResult,
});
</script>
