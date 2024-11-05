{{ define "modelName" -}}
  {{ .Values.model.organization }}/{{ .Values.model.name }}
{{- end }}

{{- define "curlCommand" -}}
  curl http://{{ .Values.service.name }}.{{ .Release.Namespace }}.svc.cluster.local/v1/completions \
    -H "Content-Type: application/json" \
    -d '{
      "model": "{{ include "modelName" . }}",
      "messages": [{"role": "user", "content": "Testing, are you there?"}],
    }'
{{- end }}

{{/*
Set the name of the vLLM resources
*/}}
{{- define "vllm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create the chart name and version for the chart label
*/}}
{{- define "chart.name" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the base labels to include on chart resources
*/}}
{{- define "base.labels" -}}
helm.sh/chart: {{ include "chart.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create selector labels to include on all resources
*/}}
{{- define "base.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create selector labels to include on all vLLM resources
*/}}
{{- define "vllm.selectorLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/component: {{ .Chart.Name }}
{{- end }}

{{/*
Create labels to include on chart all vLLM resources
*/}}
{{- define "vllm.labels" -}}
{{ include "base.labels" . }}
{{ include "vllm.selectorLabels" . }}
{{- end }}

{{ define "fullName" -}}
  {{- $serviceName := .Values.service.name | default (include "chartName" .) -}}
  {{- $namespace := .Release.Namespace | default "default" -}}
  {{ printf "%s.%s.svc.cluster.local" $serviceName $namespace }}
{{- end }}
