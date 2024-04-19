import { Ref, ref } from "vue";

export interface OllamaApiResponse {
    model: string;
    created_at: string;
    response: string;
    done: boolean;
    context: number[];
    total_duration: number;
    load_duration: number;
    prompt_eval_count: number;
    prompt_eval_duration: number;
    eval_count: number;
    eval_duration: number;
    message?: OllamaMessage;
}

export interface OllamaApiRequest {
    model: string;
    prompt?: string; // only used when stream is false
    stream: boolean;
    messages?: OllamaMessage[];
    options?: { num_predict: number };
}

export interface OllamaMessage {
    role: "user" | "assistant";
    content: string;
}

class OllamaService {
    private readonly baseUrl: string = import.meta.env.VITE_OLLAMA_API;

    async getChatResponse(requestData: OllamaApiRequest, messageRef: Ref<OllamaMessage[]>, scrollFunction: () => void) {
        try {
            const url = `${this.baseUrl}/chat`;
            const headers = {
                "Content-Type": "application/json",
            };

            const response = await fetch(url, {
                method: "POST",
                headers,
                body: JSON.stringify(requestData),
            });

            if (!response.ok) {
                throw new Error(`Erreur lors de la requête: ${response.statusText}`);
            }

            const reader = response.body?.getReader();
            if (!reader) {
                throw new Error("Le corps de la réponse ne peut pas être lu.");
            }

            const lastMessage = messageRef.value[messageRef.value.length - 1];

            const responseData = ref<OllamaMessage | null>(null);
            while (true) {
                const { done, value } = await reader.read();
                if (done) {
                    break;
                }

                const chunk = new TextDecoder().decode(value);
                const chunkData: OllamaApiResponse = JSON.parse(chunk);

                if (chunkData.message) {
                    responseData.value = chunkData.message;

                    if (lastMessage) {
                        lastMessage.content += responseData.value.content;

                        scrollFunction();
                    }
                }
            }
        } catch (error) {
            throw error;
        }
    }
}

export default OllamaService;
