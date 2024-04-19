<template>
    <div class="relative flex flex-col justify-between w-screen h-[100svh] overflow-hidden">
        <div class="z-10 flex flex-col w-full p-5 bg-white h-max gap-y-5">
            <div class="flex items-center justify-between">
                <span class="text-4xl font-semibold">IA</span>

                <div class="w-10 h-10">
                    <img v-show="loading" class="w-full h-full aspect-square" src="../assets/spinner.svg" alt="" />
                </div>
            </div>
        </div>

        <div @scroll="handleScroll" ref="messagesContainer" class="flex flex-col w-full h-full px-5 pt-10 pb-16 overflow-y-auto gap-y-10">
            <div v-for="msg in messages" class="flex w-full h-max gap-x-3">
                <!-- Image -->
                <svg v-if="msg.role == 'assistant'" class="w-6 h-6 fill-purple-500" :class="loading ? 'animate-pulse' : ''" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M7.657 6.247c.11-.33.576-.33.686 0l.645 1.937a2.89 2.89 0 0 0 1.829 1.828l1.936.645c.33.11.33.576 0 .686l-1.937.645a2.89 2.89 0 0 0-1.828 1.829l-.645 1.936a.361.361 0 0 1-.686 0l-.645-1.937a2.89 2.89 0 0 0-1.828-1.828l-1.937-.645a.361.361 0 0 1 0-.686l1.937-.645a2.89 2.89 0 0 0 1.828-1.828zM3.794 1.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387A1.73 1.73 0 0 0 4.593 5.69l-.387 1.162a.217.217 0 0 1-.412 0L3.407 5.69A1.73 1.73 0 0 0 2.31 4.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387A1.73 1.73 0 0 0 3.407 2.31zM10.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.16 1.16 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.16 1.16 0 0 0-.732-.732L9.1 2.137a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732z" />
                </svg>
                <svg v-else class="w-6 h-6 fill-blue-500" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0" />
                    <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8m8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1" />
                </svg>

                <!-- Message -->
                <div class="flex flex-col w-full gap-y-2 h-max">
                    <span class="font-medium">{{ msg.role == "assistant" ? "Assistant" : "Moi" }}</span>
                    <span>{{ msg.content }}</span>
                </div>
            </div>

            <div v-show="messages.length == 0" class="flex flex-col items-center justify-center w-full h-full gap-y-5">
                <svg class="w-20 h-20 fill-purple-500" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M7.657 6.247c.11-.33.576-.33.686 0l.645 1.937a2.89 2.89 0 0 0 1.829 1.828l1.936.645c.33.11.33.576 0 .686l-1.937.645a2.89 2.89 0 0 0-1.828 1.829l-.645 1.936a.361.361 0 0 1-.686 0l-.645-1.937a2.89 2.89 0 0 0-1.828-1.828l-1.937-.645a.361.361 0 0 1 0-.686l1.937-.645a2.89 2.89 0 0 0 1.828-1.828zM3.794 1.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387A1.73 1.73 0 0 0 4.593 5.69l-.387 1.162a.217.217 0 0 1-.412 0L3.407 5.69A1.73 1.73 0 0 0 2.31 4.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387A1.73 1.73 0 0 0 3.407 2.31zM10.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.16 1.16 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.16 1.16 0 0 0-.732-.732L9.1 2.137a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732z" />
                </svg>
                <span ref="helloContainer" class="text-3xl font-medium transition-opacity duration-[700ms]">{{ hello }}</span>
            </div>
        </div>

        <div class="relative z-10 flex items-center justify-center w-full shadow-[0px_-30px_60px_20px_rgba(255,255,255,1)] px-2 pt-2 pb-5 h-max bg-white">
            <label for="prompt" class="flex w-full p-2 px-3 border border-gray-300 rounded-full gap-x-2">
                <input v-model="prompt" @keyup.enter="handleSend" type="text" placeholder="Message..." id="prompt" name="prompt" class="w-full outline-none" />

                <button @click="handleSend" :disabled="prompt.length == 0 || loading">
                    <svg xmlns="http://www.w3.org/2000/svg" :class="prompt.length == 0 || loading ? 'fill-gray-300' : 'fill-gray-800'" class="w-8 h-8" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M16 8A8 8 0 1 0 0 8a8 8 0 0 0 16 0m-7.5 3.5a.5.5 0 0 1-1 0V5.707L5.354 7.854a.5.5 0 1 1-.708-.708l3-3a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 5.707z" />
                    </svg>
                </button>
            </label>

            <div v-show="downArrowVisible" @click="handleGoToBottom" class="absolute flex items-center justify-center p-px bg-white border border-gray-300 rounded-full -inset-y-12 w-max h-max aspect-square">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 fill-gray-800" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M8 4a.5.5 0 0 1 .5.5v5.793l2.146-2.147a.5.5 0 0 1 .708.708l-3 3a.5.5 0 0 1-.708 0l-3-3a.5.5 0 1 1 .708-.708L7.5 10.293V4.5A.5.5 0 0 1 8 4" />
                </svg>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import OllamaService, { OllamaApiRequest, OllamaMessage } from "../services/OllamaService";

const messages = ref<OllamaMessage[]>([]);

const prompt = ref<string>("");
const messagesContainer = ref<HTMLElement | null>(null);
const helloContainer = ref<HTMLElement | null>(null);
const downArrowVisible = ref<boolean>(false);
const loading = ref<boolean>(false);

// bonjour dans 20 langues
const helloList: string[] = ["Bonjour", "Hello", "Hola", "Ciao", "Hallo", "Olá", "Saluton", "Hej", "Hei", "Ahoj", "Zdravo", "Dobrý den", "Dzień dobry", "Guten Tag", "Goedendag", "Γεια σας", "こんにちは", "안녕하세요", "你好", "नमस्ते"];
const hello = ref<string>(helloList[0]);

const handleGoToBottom = () => {
    scrollToBottom("smooth");

    downArrowVisible.value = false;
};

const scrollToBottom = (mode: ScrollBehavior = "instant") => {
    messagesContainer.value?.scrollTo({
        top: messagesContainer.value.scrollHeight,
        behavior: mode,
    });

    downArrowVisible.value = false;
};

const handleScroll = () => {
    if (messagesContainer.value) {
        const { scrollTop, scrollHeight, clientHeight } = messagesContainer.value;

        downArrowVisible.value = scrollTop + clientHeight < scrollHeight;
    }
};

const handleSend = async () => {
    if (prompt.value.length == 0 || loading.value) return;

    loading.value = true;

    await sendMessage(prompt.value, "user");

    loading.value = false;
};

const sendMessage = async (message: string, role: "user" | "assistant") => {
    messages.value.push({
        role: role,
        content: message,
    });

    messages.value.push({
        role: "assistant",
        content: "",
    });

    prompt.value = "";

    setTimeout(scrollToBottom, 1);

    const requestData: OllamaApiRequest = {
        model: import.meta.env.VITE_OLLAMA_MODEL,
        messages: messages.value,
        stream: true,
        options: { num_predict: parseInt(import.meta.env.VITE_OLLAMA_MAX_TOKENS) },
    };

    await new OllamaService().getChatResponse(requestData, messages, scrollToBottom);
};

onMounted(async () => {
    console.log("AI mounted");

    // Wait for 3 seconds
    await new Promise((resolve) => setTimeout(resolve, 3000));

    // Initialize index for helloList
    let i = 0;

    // Loop until the end of helloList
    while (messages.value.length == 0) {
        helloContainer.value?.classList.add("opacity-0");
        await new Promise((resolve) => setTimeout(resolve, 700));

        // Show the current hello message
        hello.value = helloList[i + 1];

        helloContainer.value?.classList.remove("opacity-0");

        // Wait for 3 seconds
        await new Promise((resolve) => setTimeout(resolve, 3000));

        // Increment index for the next hello message
        i++;

        if (i == helloList.length - 1) {
            i = -1;
        }
    }
});
</script>
