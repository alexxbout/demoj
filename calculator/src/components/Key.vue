<template>
    <button @click.prevent="emits('@click')" class="flex items-center justify-center w-full h-20 p-5 text-3xl text-center duration-200 active:scale-95 rounded-3xl aspect-square disabled:grayscale" :style="styles" :disabled="props.disabled">
        <span v-if="props.type != 'delete'">{{ props.text }}</span>

        <svg v-else class="w-12 h-12 fill-black" xmlns="http://www.w3.org/2000/svg" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink" width="512" height="512" x="0" y="0" viewBox="0 0 24 24" style="enable-background: new 0 0 512 512" xml:space="preserve">
            <g>
                <path d="M19 19.75H8.36a3.747 3.747 0 0 1-2.851-1.314l-3.97-4.65a2.737 2.737 0 0 1 0-3.572l3.97-4.649A3.744 3.744 0 0 1 8.36 4.25H19A3.755 3.755 0 0 1 22.75 8v8A3.755 3.755 0 0 1 19 19.75zm-10.64-14a2.25 2.25 0 0 0-1.711.789L2.68 11.188a1.244 1.244 0 0 0 0 1.624l3.969 4.649a2.25 2.25 0 0 0 1.711.789H19A2.253 2.253 0 0 0 21.25 16V8A2.253 2.253 0 0 0 19 5.75z" opacity="1"></path>
                <path d="M11 14.75a.75.75 0 0 1-.53-1.28l4-4a.75.75 0 0 1 1.06 1.06l-4 4a.744.744 0 0 1-.53.22z" opacity="1"></path>
                <path d="M15 14.75a.744.744 0 0 1-.53-.22l-4-4a.75.75 0 0 1 1.06-1.06l4 4a.75.75 0 0 1-.53 1.28z" opacity="1"></path>
            </g>
        </svg>
    </button>
</template>

<script setup lang="ts">
import { StyleValue, computed } from "vue";

const props = defineProps<{
    text?: string;
    type: "number" | "operator" | "equal" | "ac" | "delete";
    span?: number;
    disabled?: boolean;
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
        case "delete":
            styles["background-color"] = "#D5D5D5";
            styles["color"] = "#000000";
            return styles;
        case "ac":
            styles["background-color"] = "#FC5B5B";
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
