<template>
    <ion-card>
        <ion-card-header>
            <ion-card-title>{{ props.data.name }}</ion-card-title>
        </ion-card-header>

        <ion-card-content>{{ props.data.description }}</ion-card-content>

        <ion-button @click="go" class="ion-padding" expand="block">Voir le scénario</ion-button>
    </ion-card>
</template>

<script setup lang="ts">
import { IScenario } from "@/types/IConfig";
import { IonButton, IonCard, IonCardContent, IonCardHeader, IonCardTitle } from "@ionic/vue";
import { useRouter } from "vue-router";

const props = defineProps<{
    data: IScenario;
}>();

const router = useRouter();

const go = () => {
    router.push({ name: "scenario-details", params: { id: props.data.id } });
};
</script>
