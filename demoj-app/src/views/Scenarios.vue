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

            <ion-button color="secondary" class="ion-padding" expand="block">Voir les scénarios en cours</ion-button>

            <scenario-card :data="sc[0]" />

            <scenario-card :data="sc[1]" />

            <scenario-card :data="sc[2]" />
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import ScenarioCard from "@/components/ScenarioCard.vue";
import { IonButton, IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from "@ionic/vue";
import { calculator, image, reader } from "ionicons/icons";
import { ref } from "vue";

const sc = ref([
    {
        id: 1,
        title: "Calculs complexes",
        subtitle: "Terminal",
        icon: calculator,
        description: "Effectuez des calculs avancés, démontrant la puissance de traitement du serveur dans des tâches informatiques complexes.",
    },
    {
        id: 2,
        title: "Conversion de données",
        subtitle: "Terminal",
        icon: reader,
        description: "Transformez le format des données avec cette fonctionnalité du terminal.",
    },
    {
        id: 3,
        title: "Upscale d'Image",
        subtitle: "Terminal",
        icon: image,
        description: "Augmentez la résolution des images avec ce scénario performant.",
    },
]);
</script>
