# vLLM Helm Chart
Helm chart to deploy the vLLM OpenAI-compatible inference engine on Kubernetes. 

## Getting Started
You can add the repository by running:
`helm repo add vllm https://open-source-ai-dev.github.io/vllm-helm-chart`

Then, you can install the Helm chart by running:
`helm install vllm-llama-3.2 vllm/vllm --set hfToken=<HuggingFace token>`
