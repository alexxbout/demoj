<template>
    <ion-page>
        <ion-header>
            <ion-toolbar>
                <ion-buttons slot="start">
                    <ion-back-button defaultHref="/tabs/scenarios" text="Retour"></ion-back-button>
                </ion-buttons>
                <ion-title>Détails</ion-title>
            </ion-toolbar>
        </ion-header>
        <ion-content class="ion-padding">
            <div v-if="current" style="height: 100%; display: flex; flex-direction: column; justify-items: center; align-items: center; justify-content: space-between">
                <div>
                    <ion-list :inset="true" style="margin: 0">
                        <ion-item>
                            <ion-grid>
                                <ion-row>
                                    <ion-text>
                                        <h2>Description</h2>
                                        <p>{{ current.description }}</p>
                                    </ion-text>
                                </ion-row>
                                <ion-row>
                                    <ion-col>
                                        <ion-text>
                                            <h2>Impact sur le système</h2>
                                        </ion-text>
                                        <ion-chip v-for="stress in current.stress" :key="stress" color="danger" class="ion-no-margin" style="margin-right: 10px">{{ stress }}</ion-chip>
                                    </ion-col>
                                </ion-row>
                                <ion-row v-if="mode == 'operator' && current.scenario == Scenario.Calculator">
                                    <ion-text>
                                        <h2>Calculs côté terminal</h2>
                                    </ion-text>
                                    <ion-toggle @ion-change="handleBackendCalculator" v-model="isBackendCalculator" :disabled="isDisabled">Executer des calculs en fond de tâche</ion-toggle>
                                </ion-row>
                            </ion-grid>
                        </ion-item>
                    </ion-list>
                </div>

                <div style="height: max-content; width: 100%; display: flex; flex-direction: column; align-items: center">
                    <ion-chip v-if="isDisabled" color="danger">
                        <span>
                            <span>Ce scénario est indisponible car </span>
                            <span v-for="(need, index) in current.needs" :key="index">{{ need + " " }}</span>

                            <span v-show="current.needs.length == 1">n'est pas connecté</span>
                            <span v-show="current.needs.length > 1">ne sont pas connectés</span>
                        </span>
                    </ion-chip>
                    <ion-button @click="handleClick" expand="block" style="width: 100%" :disabled="isDisabled">Accéder à l'application</ion-button>
                </div>
            </div>
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import { Zocket } from "@/services/Zocket";
import { DeviceType } from "@/types/IConfig";
import { IonBackButton, IonButton, IonButtons, IonChip, IonCol, IonContent, IonGrid, IonHeader, IonItem, IonList, IonPage, IonRow, IonText, IonTitle, IonToggle, IonToolbar } from "@ionic/vue";
import { computed, inject, onMounted, ref } from "vue";
import { useRoute } from "vue-router";

enum Scenario {
    Calculator = "calculator",
    AI = "ai",
    Streaming = "streaming",
}

enum StressType {
    CPU = "CPU",
    MEMORY = "RAM",
    NETWORK = "RÉSEAU",
}

interface ScenarioData {
    scenario: Scenario;
    description: string;
    url: string;
    stress: StressType[];
    needs: DeviceType[];
}

const socket = inject("socket") as Zocket;
const config = socket.getConfig();

const mode = ref<"client" | "operator">(localStorage.getItem("mode") === "operator" ? "operator" : "client");

const isDisabled = computed(() => {
    for (const need of current.value?.needs || []) {
        if (!config.value?.modules[need].isConnected) {
            return true;
        }
    }

    return false;
});

const baseUrl = `http://${import.meta.env.VITE_IP_SERVER}:5000/`;

const route = useRoute();

const data: ScenarioData[] = [
    {
        scenario: Scenario.Calculator,
        description: "Cette fonctionnalité permet aux utilisateurs d'effectuer une gamme étendue de calculs, depuis des opérations basiques jusqu'à des fonctions mathématiques avancées comme Fibonacci, factorielle et recherche de nombres premiers. Le tout peut être réalisé côté client ou côté serveur.",
        url: `${baseUrl}calculator`,
        stress: [StressType.CPU, StressType.MEMORY],
        needs: [],
    },
    {
        scenario: Scenario.Streaming,
        description: "Cette fonctionnalité permet aux utilisateurs de regarder des vidéos en streaming avec des fonctionnalités de contrôle similaires à Youtube.",
        url: `${baseUrl}streaming`,
        stress: [StressType.NETWORK],
        needs: ["server"],
    },
    {
        scenario: Scenario.AI,
        description: "Cette fonctionnalité permet aux utilisateurs de communiquer avec une IA conversationnelle similaire à ChatGPT.",
        url: `${baseUrl}ai`,
        stress: [StressType.MEMORY, StressType.NETWORK],
        needs: ["server"],
    },
];

const current = ref<ScenarioData | null>(null);

// TODO: Use a computed property instead of a ref
const isBackendCalculator = ref(config.value?.isBackendCalculator || false);

const handleClick = () => {
    const scenario = data.find((d) => d.scenario === route.name);
    if (scenario) {
        location.href = scenario.url;
    }
};

const handleBackendCalculator = () => {
    console.log("backendCalculator", isBackendCalculator.value);

    socket.sendTerminalCalculation(isBackendCalculator.value);
};

onMounted(() => {
    const scenario = data.find((d) => d.scenario === route.name);

    if (scenario) {
        current.value = scenario;
    }
});
</script>
