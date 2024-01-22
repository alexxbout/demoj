import { createRouter, createWebHistory } from "@ionic/vue-router";
import { RouteRecordRaw } from "vue-router";
import Tabs from "../views/Tabs.vue";

const routes: Array<RouteRecordRaw> = [
    {
        path: "/",
        name: "home",
        component: () => import("@/views/Home.vue"),
    },
    {
        path: "/tabs/",
        redirect: "/tabs/scenarios",
        component: Tabs,
        children: [
            {
                path: "scenarios",
                name: "scenarios",
                component: () => import("@/views/Scenarios.vue"),
            },
            {
                path: "debug",
                name: "debug",
                component: () => import("@/views/Debug.vue"),
                beforeEnter: (to, from, next) => {
                    const storedDebugMode = localStorage.getItem("debugMode");
                    if (storedDebugMode === "true") {
                        next();
                    } else {
                        next({ name: "home" });
                    }
                },
            },
            {
                path: "scenarios/:id",
                name: "scenario-details",
                component: () => import("@/views/ScenarioDetails.vue"),
            },
            {
                path: "terminal",
                name: "terminal",
                component: () => import("@/views/modules/Terminal.vue"),
            },
            {
                path: "network",
                name: "network",
                component: () => import("@/views/modules/Network.vue"),
            },
            {
                path: "server",
                name: "server",
                component: () => import("@/views/modules/Server.vue"),
            },
        ],
    },
];

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
});

export default router;
