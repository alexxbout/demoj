<template>
    <button @click.prevent="emits('@click')" :class="props.span ? 'w-full justify-start' : 'w-20 flex justify-center'" class="flex items-center h-20 p-6 text-3xl rounded-full disabled:grayscale" :style="styles">
        <span>{{ props.text }}</span>
    </button>
</template>

<script setup lang="ts">
import { StyleValue, computed } from "vue";

const props = defineProps<{
    text: string;
    type: "number" | "operator" | "action";
    span?: number;
}>();

const emits = defineEmits<{
    (e: "@click"): void;
}>();

const styles = computed<StyleValue>(() => {
    const styles = {
        backgroundColor: "#FFFFFF",
        color: "#000000",
        gridColumn: `span ${props.span || 1}`,
    };

    switch (props.type) {
        case "number":
            styles.backgroundColor = "#E6E6E6";
            styles.color = "#000000";
            break;
        case "operator":
            styles.backgroundColor = "#ff9f0a";
            styles.color = "#FFFFFF";
            break;
        case "action":
            styles.backgroundColor = "#CBCBCB";
            styles.color = "#000000";
    }

    return styles;
});
</script>
