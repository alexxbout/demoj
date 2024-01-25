import { createRouter, createWebHistory } from "@ionic/vue-router";
import { NavigationGuardNext, RouteLocationNormalized, RouteRecordRaw } from "vue-router";

// Import des composants
import Debug from "@/views/Debug.vue";
import Home from "@/views/Home.vue";
import ScenarioDetails from "@/views/ScenarioDetails.vue";
import Scenarios from "@/views/Scenarios.vue";
import Tabs from "@/views/Tabs.vue";
import Network from "@/views/modules/Network.vue";
import Server from "@/views/modules/Server.vue";
import Terminal from "@/views/modules/Terminal.vue";

// Déclaration de la fonction authGuard avant son utilisation
const authGuard = (to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) => {
    const mode = localStorage.getItem("mode");
    if (mode === "client") {
        next({ name: "home" });
    } else {
        next();
    }
};

const routes: Array<RouteRecordRaw> = [
    {
        path: "/",
        redirect: "/home",
    },
    {
        path: "/home",
        name: "home",
        component: Home,
    },
    {
        path: "/tabs/",
        redirect: "/tabs/scenarios",
        component: Tabs,
        children: [
            {
                path: "scenarios",
                name: "scenarios",
                component: Scenarios,
            },
            {
                path: "debug",
                name: "debug",
                component: Debug,
                beforeEnter: (to, from, next) => {
                    const debugMode = localStorage.getItem("debugMode");
                    const mode = localStorage.getItem("mode");
                    if (mode === "operator" && debugMode === "true") {
                        next();
                    } else {
                        next({ name: "home" });
                    }
                },
            },
            {
                path: "scenarios/:id",
                name: "scenario-details",
                component: ScenarioDetails,
            },
            {
                path: "terminal",
                name: "terminal",
                component: Terminal,
                beforeEnter: authGuard,
            },
            {
                path: "network",
                name: "network",
                component: Network,
                beforeEnter: authGuard,
            },
            {
                path: "server",
                name: "server",
                component: Server,
                beforeEnter: authGuard,
            },
        ],
    },
];

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
});

export default router;