import { createApp } from "vue";
import { RouteRecordRaw, createRouter, createWebHistory } from "vue-router";
import App from "./App.vue";
import "./style.css";

const routes: Array<RouteRecordRaw> = [
    {
        path: "/",
        name: "home",
        component: () => import("./App.vue")
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

createApp(App).use(router).mount("#app");
