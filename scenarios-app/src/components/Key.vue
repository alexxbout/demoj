<template>
    <button @click.prevent="emits('@click')" :class="props.span ? 'w-full justify-start' : 'w-20 flex justify-center'" class="flex items-center h-20 p-6 text-3xl transition-all duration-200 rounded-full disabled:grayscale" :style="styles" :disabled="props.disabled">
        <span>{{ props.text }}</span>
    </button>
</template>

<script setup lang="ts">
import { StyleValue, computed } from "vue";

const props = defineProps<{
    text: string;
    type: "number" | "operator" | "action" | "function";
    span?: number;
    disabled?: boolean;
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
            styles.backgroundColor = "#007AFF";
            styles.color = "#FFFFFF";
            break;
        case "action":
            styles.backgroundColor = "#C4C4C4";
            styles.color = "#000000";
            break;
        case "function":
            styles.backgroundColor = "#54BC3A";
            styles.color = "#FFFFFF";
    }

    return styles;
});
</script>
