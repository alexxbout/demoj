<template>
    <button @click="emits('@click')" class="flex items-center justify-center w-full h-20 p-5 text-3xl text-center aspect-square rounded-3xl" :style="styles">
        <span>{{ props.text }}</span>
    </button>
</template>

<script setup lang="ts">
import { StyleValue, computed } from "vue";

const props = defineProps<{
    text: string;
    type: "number" | "operator" | "equal" | "delete";
    span?: number;
}>();

const emits = defineEmits<{
    (e: "@click"): void;
}>();

const styles = computed<StyleValue>(() => {
    const styles = {
        "background-color": "#FFFFFF",
        color: "#000000",
        "grid-column": `span ${props.span || 1}`,
    };

    switch (props.type) {
        case "number":
            return styles;
        case "operator":
            styles["background-color"] = "#4B5EFC";
            styles["color"] = "#FFFFFF";
            return styles;
        case "delete":
            styles["background-color"] = "#FF6B6B";
            styles["color"] = "#FFFFFF";
            return styles;
        case "equal":
            styles["background-color"] = "#FFA500";
            styles["color"] = "#FFFFFF";
            return styles;
        default:
            return styles;
    }
});
</script>
