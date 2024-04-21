import { createRouter, createWebHistory } from "@ionic/vue-router";
import { NavigationGuardNext, RouteLocationNormalized, RouteRecordRaw } from "vue-router";

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
        component: () => import("@/views/Home.vue"),
    },
    {
        path: "/tabs/",
        redirect: "/tabs/scenarios",
        component: () => import("@/views/Tabs.vue"),
        children: [
            {
                path: "scenarios",
                name: "scenarios",
                component: () => import("@/views/Scenarios.vue"),
            },
            {
                path: "scenarios/calculator",
                name: "calculator",
                component: () => import("@/views/scenarios/Calculator.vue"),
            },
            {
                path: "scenarios/ai",
                name: "ai",
                component: () => import("@/views/scenarios/AI.vue"),
            },
            {
                path: "scenarios/streaming",
                name: "streaming",
                component: () => import("@/views/scenarios/Streaming.vue"),
            },
            {
                path: "debug",
                name: "debug",
                component: () => import("@/views/Debug.vue"),
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
                path: "terminal",
                name: "terminal",
                component: () => import("@/views/modules/Terminal.vue"),
                beforeEnter: authGuard,
            },
            {
                path: "network",
                name: "network",
                component: () => import("@/views/modules/Network.vue"),
                beforeEnter: authGuard,
            },
            {
                path: "server",
                name: "server",
                component: () => import("@/views/modules/Server.vue"),
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