{{/*
Get the environment suffix. Eg. prod, dev, sandbox
*/}}
{{- define "quai-cicd.envSuffix" -}}
{{- (split "-" .Values.quaiCicd.env)._1 -}}
{{- end }}

{{/*
Get the environment URL prefix where prod is ""
*/}}
{{- define "quai-cicd.envPrefix" -}}
{{- $suffix := include "quai-cicd.envSuffix" . -}}
{{- if eq $suffix "prod" }}{{- else }}
{{- $suffix -}}.{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "quai-cicd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}-{{- include "quai-cicd.envSuffix" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "quai-cicd.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "quai-cicd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "quai-cicd.labels" -}}
helm.sh/chart: {{ include "quai-cicd.chart" . }}
{{ include "quai-cicd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "quai-cicd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quai-cicd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "quai-cicd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "quai-cicd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
