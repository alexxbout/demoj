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

            <!-- <div v-show="mode == 'operator'" class="ion-padding">
                <RunningScenarios :presenting="presenting" />
            </div> -->

            <scenario-card v-for="scenario in scenarios" :data="scenario" />
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import ScenarioCard from "@/components/ScenarioCard.vue";
import { Chaussette } from "@/services/Chaussette";
import type { IScenario } from "@/types/IConfig";
import { IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from "@ionic/vue";
import { computed, inject, onMounted, ref } from "vue";

const page = ref();
const presenting = ref();

const socket = inject("socket") as Chaussette;
const config = socket.getConfig();

const scenarios = computed<IScenario[]>(() => config.value?.scenarios ?? []);

const mode = ref<"client" | "operator">("client");

onMounted(() => {
    mode.value = localStorage.getItem("mode") as "client" | "operator";

    presenting.value = page.value.$el;
});
</script>
