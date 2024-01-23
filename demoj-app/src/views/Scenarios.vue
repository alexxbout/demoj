<template>
    <ion-page>
        <ion-header>
            <ion-toolbar>
                <ion-title>Scénarios</ion-title>
            </ion-toolbar>
        </ion-header>

        <ion-content :fullscreen="true">
            <ion-header collapse="condense">
                <ion-toolbar>
                    <ion-title size="large">Scénarios</ion-title>
                </ion-toolbar>
            </ion-header>

            <scenario-card v-for="scenario in scenarios" :data="scenario" />
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import ScenarioCard from "@/components/ScenarioCard.vue";
import API from "@/services/API";
import type { IScenario } from "@/types/IConfig";
import { IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from "@ionic/vue";
import { onMounted, ref } from "vue";

const scenarios = ref<IScenario[]>([]);

onMounted(async () => {
    scenarios.value = await API.getScenarios();
});
</script>
