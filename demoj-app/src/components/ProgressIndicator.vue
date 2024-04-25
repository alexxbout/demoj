<template>
    <ion-item v-if="show">
        <ion-grid>
            <ion-row class="ion-align-items-center">
                <ion-label>{{ props.title }}</ion-label>
                <ion-spinner v-show="counter < props.time"></ion-spinner>
                <ion-icon v-show="counter >= props.time" :icon="checkmarkCircle" size="large" color="success"></ion-icon>
            </ion-row>
        </ion-grid>
    </ion-item>
</template>

<script setup lang="ts">
import { IonGrid, IonIcon, IonItem, IonLabel, IonRow, IonSpinner } from "@ionic/vue";
import { checkmarkCircle } from "ionicons/icons";
import { onMounted, ref } from "vue";

const props = defineProps<{
    title: string;
    time: number;
}>();

const show = ref(true);
const counter = ref(0);

onMounted(() => {
    // Increment the counter every second
    const interval = setInterval(() => {
        counter.value++;
        if (counter.value === props.time) {
            clearInterval(interval);
            setTimeout(() => {
                show.value = false;
            }, 3000);
        }
    }, 1000);
});
</script>
