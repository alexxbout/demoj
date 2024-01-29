<template>
    <ion-chip style="border-radius: 9999px; height: 32px;">
        <ion-label>{{ props.level + "% &nbsp;" }}</ion-label>
        <ion-icon :icon="icon" :style="{ color: color, fontSize: '25px'}" class="ion-no-margin" />
    </ion-chip>
</template>

<script setup lang="ts">
import { IonChip, IonIcon, IonLabel } from "@ionic/vue";
import { batteryDead, batteryFull, batteryHalf } from "ionicons/icons";
import { computed } from "vue";

const props = defineProps({
    level: {
        type: Number,
        required: true,
    },
});

const icons = {
    low: batteryDead,
    medium: batteryHalf,
    high: batteryFull,
};

const icon = computed(() => {
    if (props.level <= 20) return icons.low;
    if (props.level <= 50) return icons.medium;
    return icons.high;
});

const color = computed(() => {
    if (props.level <= 20) return "#FF3B30";
    if (props.level <= 50) return "#FF9500";
    return "#34C759";
});
</script>