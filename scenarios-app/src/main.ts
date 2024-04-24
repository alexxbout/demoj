import { createApp } from "vue";
import { RouteRecordRaw, createRouter, createWebHistory } from "vue-router";
import App from "./App.vue";
import "./style.css";

const routes: Array<RouteRecordRaw> = [
    {
        path: "/app/calculator",
        name: "calculator",
        component: () => import("./scenarios/Calculator.vue"),
    },
    {
        path: "/app/ai",
        name: "ai",
        component: () => import("./scenarios/AI.vue"),
    },
    {
        path: "/app/streaming",
        name: "streaming",
        component: () => import("./scenarios/Streaming.vue"),
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

createApp(App).use(router).mount("#app");
