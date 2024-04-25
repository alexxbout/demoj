import { createApp } from "vue";
import { RouteRecordRaw, createRouter, createWebHistory } from "vue-router";
import App from "./App.vue";
import "./style.css";

const routes: Array<RouteRecordRaw> = [
    {
        path: "/calculator",
        name: "calculator",
        component: () => import("./scenarios/Calculator.vue"),
    },
    {
        path: "/ai",
        name: "ai",
        component: () => import("./scenarios/AI.vue"),
    },
    {
        path: "/streaming",
        name: "streaming",
        component: () => import("./scenarios/Streaming.vue"),
    }
];

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
});

createApp(App).use(router).mount("#app");
