<template>
    <router-view />
</template>

<script setup lang="ts">
import { onMounted } from "vue";

onMounted(() => {
    console.log("App mounted");

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
