<template>
    <ion-card>
        <ion-card-header>
            <ion-card-title>{{ props.data.title }}</ion-card-title>
            <ion-card-subtitle>{{ props.data.subtitle }}</ion-card-subtitle>
        </ion-card-header>

        <ion-grid style="--ion-grid-padding: 25px;">
            <ion-row class="ion-justify-content-center">
                <ion-icon style="font-size: 70px;" :icon="props.data.icon"></ion-icon>
            </ion-row>
        </ion-grid>

        <ion-card-content>{{ props.data.description }}</ion-card-content>

        <ion-button @click="go()" class="ion-padding" expand="block">Voir le scénario</ion-button>
    </ion-card>
</template>

<script setup lang="ts">
import { IonButton, IonCard, IonCardContent, IonCardHeader, IonCardSubtitle, IonCardTitle, IonGrid, IonIcon, IonRow } from "@ionic/vue";
import { useRouter } from "vue-router";

const props = defineProps<{
    data: {
        id: number;
        title: string;
        subtitle: string;
        icon: string;
        description: string;
    };
}>();

const router = useRouter();

const go = () => {
    router.push("/tabs/scenarios/" + props.data.id);
};
</script>

<!-- <style scoped>
ion-icon {
    font-size: 70px;
}

ion-grid {
    --ion-grid-padding: 25px;
}
</style> -->
