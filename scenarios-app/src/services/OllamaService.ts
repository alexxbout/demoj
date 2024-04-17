import axios, { AxiosResponse } from 'axios';

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
}

export interface OllamaApiRequest {
  model: string;
  prompt: string;
  stream: boolean;
}

class OllamaService {
  private readonly baseUrl: string;
  private readonly defaultOptions: Partial<OllamaApiRequest>;

  constructor(baseUrl: string, defaultOptions: Partial<OllamaApiRequest> = {}) {
    this.baseUrl = baseUrl;
    this.defaultOptions = defaultOptions;
  }

  async generateResponse(requestData: OllamaApiRequest): Promise<OllamaApiResponse | OllamaApiResponse[]> {
    try {
      const response = await axios.post<OllamaApiRequest, AxiosResponse<OllamaApiResponse | OllamaApiResponse[]>>(
        `${this.baseUrl}/generate`,
        requestData
      );
      return response.data;
    } catch (error) {
      // Gérer les erreurs ici
      throw error;
    }
  }
}

export default OllamaService;
