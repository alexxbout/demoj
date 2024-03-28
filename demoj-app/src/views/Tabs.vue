<template>
    <ion-page>
        <ion-tabs>
            <ion-router-outlet animated="true" />
            <ion-tab-bar v-show="mode == 'operator'" slot="bottom">
                <ion-tab-button tab="scenarios" href="/tabs/scenarios">
                    <ion-icon :icon="layers" />
                    <ion-label>Scénarios</ion-label>
                </ion-tab-button>

                <ion-tab-button tab="terminal" href="/tabs/terminal">
                    <ion-icon :icon="phonePortrait" />
                    <ion-label>Terminal</ion-label>

                    <div v-show="!status.terminal" style="background-color: #eb445a; position: absolute; top: 2px; right: auto; left: auto; margin-left: 30px; width: 17px; height: 17px; border-radius: 9999px" />
                </ion-tab-button>

                <ion-tab-button tab="network" href="/tabs/network">
                    <ion-icon :icon="globe" />
                    <ion-label>Réseau</ion-label>

                    <div v-show="!status.network" style="background-color: #eb445a; position: absolute; top: 2px; right: auto; left: auto; margin-left: 30px; width: 17px; height: 17px; border-radius: 9999px" />
                </ion-tab-button>

                <ion-tab-button tab="server" href="/tabs/server">
                    <ion-icon :icon="server" />
                    <ion-label>Serveur</ion-label>

                    <div v-show="!status.server" style="background-color: #eb445a; position: absolute; top: 2px; right: auto; left: auto; margin-left: 30px; width: 17px; height: 17px; border-radius: 9999px" />
                </ion-tab-button>

                <ion-tab-button v-show="debugModeEnabled" tab="debug" href="/tabs/debug">
                    <ion-icon :icon="hardwareChip" />
                    <ion-label>Debug</ion-label>
                </ion-tab-button>
            </ion-tab-bar>
        </ion-tabs>
    </ion-page>
</template>

<script setup lang="ts">
import { Chaussette } from "@/services/Chaussette";
import { IonIcon, IonLabel, IonPage, IonRouterOutlet, IonTabBar, IonTabButton, IonTabs } from "@ionic/vue";
import { globe, hardwareChip, layers, phonePortrait, server } from "ionicons/icons";
import { computed, inject, ref } from "vue";

const socket = inject("socket") as Chaussette;
const config = socket.getConfig();

const status = computed(() => {
    return {
        terminal: config.value?.modules.terminal.isConnected ?? false,
        network: config.value?.modules.network.isConnected ?? false,
        server: config.value?.modules.server.isConnected ?? false,
    };
});

const mode = ref<"client" | "operator">(localStorage.getItem("mode") === "operator" ? "operator" : "client");
const debugModeEnabled = ref(localStorage.getItem("debugMode") === "true");
</script>

<style scoped>
ion-tab-button {
    position: relative;
}
</style>
@/services/Chaussette