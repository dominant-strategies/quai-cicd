{{/*
Get the environment suffix. Eg. prod, dev, sandbox
*/}}
{{- define "test-cicd.envSuffix" -}}
{{- (split "-" .Values.testCicd.env)._1 -}}
{{- end }}

{{/*
Get the environment URL prefix where prod is ""
*/}}
{{- define "test-cicd.envPrefix" -}}
{{- $suffix := include "test-cicd.envSuffix" . -}}
{{- if eq $suffix "prod" }}{{- else }}
{{- $suffix -}}.{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "test-cicd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}-{{- include "test-cicd.envSuffix" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "test-cicd.fullname" -}}
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
{{- define "test-cicd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "test-cicd.labels" -}}
helm.sh/chart: {{ include "test-cicd.chart" . }}
{{ include "test-cicd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "test-cicd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "test-cicd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "test-cicd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "test-cicd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
