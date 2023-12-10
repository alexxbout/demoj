<template>
    <ion-page ref="page">
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

            <scenario-card :data="sc[0]" />
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import ScenarioCard from "@/components/ScenarioCard.vue";
import { IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from "@ionic/vue";
import { calculator } from "ionicons/icons";
import { ref } from "vue";

const sc = ref([
    {
        id: 1,
        title: "Calculs complexes",
        subtitle: "Terminal",
        icon: calculator,
        description: "Effectuez des calculs avancés, démontrant la puissance de traitement du serveur dans des tâches informatiques complexes.",
    }
]);
</script>
