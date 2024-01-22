import { createRouter, createWebHistory } from '@ionic/vue-router';
import { RouteRecordRaw } from 'vue-router';
import Tabs from '../views/Tabs.vue';

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/tabs/',
    redirect: '/tabs/scenarios',
    component: Tabs,
    children: [
      {
        path: 'scenarios',
        name: 'scenarios',
        component: () => import('@/views/Scenarios.vue')
      },
      {
        path: 'debug',
        component: () => import('@/views/Debug.vue')
      },
      {
        path: 'scenarios/:id',
        component: () => import('@/views/ScenarioDetails.vue')
      },
      {
        path: 'terminal',
        component: () => import('@/views/modules/Terminal.vue')
      },
      {
        path: 'network',
        component: () => import('@/views/modules/Network.vue')
      },
      {
        path: 'server',
        component: () => import('@/views/modules/Server.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router
