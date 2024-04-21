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

            <scenario-card v-for="scenario in scenarios" :data="scenario" />
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import ScenarioCard from "@/components/ScenarioCard.vue";
import type { IScenario } from "@/types/IConfig";
import { IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from "@ionic/vue";
import { calculator, logoYoutube, sparkles } from "ionicons/icons";
import { onMounted, ref } from "vue";

const page = ref();
const presenting = ref();

const scenarios = ref<IScenario[]>([
    {
        name: "calculator",
        title: "Calculatrice",
        description: "Effectuez des calculs simples ou exécutez des fonctions complexes, côté client ou serveur.",
        icon: calculator,
    },
    {
        name: "ai",
        title: "Intelligence Artificielle",
        description: "Générez du texte avec une IA conversationnelle similaire à ChatGPT.",
        icon: sparkles,
    },
    {
        name: "streaming",
        title: "Streaming Vidéo",
        description: "Regardez des vidéos en streaming avec des fonctionnalités de contrôle similaires à Youtube.",
        icon: logoYoutube,
    }
]);

const mode = ref<"client" | "operator">("client");

onMounted(() => {
    mode.value = localStorage.getItem("mode") as "client" | "operator";

    presenting.value = page.value.$el;
});
</script>
