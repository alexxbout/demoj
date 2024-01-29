<template>
    <ion-chip style="--color: white" :style="{ '--background': props.isConnected ? '#34C759' : '#FF3B30' }">
        <ion-label>{{ props.isConnected ? "Connecté" : "Hors ligne" }}</ion-label>
    </ion-chip>
</template>

<script setup lang="ts">
import { IonChip, IonLabel } from "@ionic/vue";
const props = defineProps({
    isConnected: {
        type: Boolean,
        required: true,
    },
});
</script>
