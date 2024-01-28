<template>
    <ion-page>
        <ion-tabs>
            <ion-router-outlet animated="true" />
            <ion-tab-bar v-show="mode == 'operator'" slot="bottom">
                <ion-tab-button tab="scenarios" href="/tabs/scenarios">
                    <ion-icon aria-hidden="true" :icon="layers" />
                    <ion-label>Scénarios</ion-label>
                </ion-tab-button>

                <ion-tab-button tab="terminal" href="/tabs/terminal">
                    <ion-icon aria-hidden="true" :icon="desktop" />
                    <ion-label>Terminal</ion-label>

                    <div v-show="!status.terminal" style="background-color: #eb445a; position: absolute; top: 2px; right: 16px; width: 17px; height: 17px; border-radius: 9999px" />
                </ion-tab-button>

                <ion-tab-button tab="network" href="/tabs/network">
                    <ion-icon aria-hidden="true" :icon="wifi" />
                    <ion-label>Réseau</ion-label>

                    <div v-show="!status.network" style="background-color: #eb445a; position: absolute; top: 2px; right: 16px; width: 17px; height: 17px; border-radius: 9999px" />
                </ion-tab-button>

                <ion-tab-button tab="server" href="/tabs/server">
                    <ion-icon aria-hidden="true" :icon="terminal" />
                    <ion-label>Serveur</ion-label>

                    <div v-show="!status.server" style="background-color: #eb445a; position: absolute; top: 2px; right: 16px; width: 17px; height: 17px; border-radius: 9999px" />
                </ion-tab-button>

                <ion-tab-button v-show="debugModeEnabled" tab="debug" href="/tabs/debug">
                    <ion-icon aria-hidden="true" :icon="hardwareChip" />
                    <ion-label>Debug</ion-label>
                </ion-tab-button>
            </ion-tab-bar>
        </ion-tabs>
    </ion-page>
</template>

<script setup lang="ts">
import { CustomSocket } from "@/services/CustomSocket";
import { IonIcon, IonLabel, IonPage, IonRouterOutlet, IonTabBar, IonTabButton, IonTabs } from "@ionic/vue";
import { desktop, hardwareChip, layers, terminal, wifi } from "ionicons/icons";
import { computed, inject, onMounted, ref } from "vue";

const socket = inject("socket") as CustomSocket;
const config = socket.getConfig();

const status = computed(() => {
    return {
        terminal: config.value?.modules.terminal.isConnected ?? false,
        network: config.value?.modules.network.isConnected ?? false,
        server: config.value?.modules.server.isConnected ?? false,
    };
});

const mode = ref<"client" | "operator">("client");
const debugModeEnabled = ref(false);

onMounted(() => {
    if (localStorage.getItem("debugMode") === "true") debugModeEnabled.value = true;
    if (localStorage.getItem("mode") === "operator") mode.value = "operator";
});
</script>

<style scoped>
ion-tab-button {
    position: relative;
}
</style>
