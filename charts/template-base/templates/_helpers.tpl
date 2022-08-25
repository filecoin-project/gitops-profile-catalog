{{/*
Expand the name of the chart.
*/}}
{{- define "template-base.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "template-base.fullname" -}}
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
{{- define "template-base.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "template-base.labels" -}}
helm.sh/chart: {{ include "template-base.chart" . }}
{{ include "template-base.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "template-base.selectorLabels" -}}
app.kubernetes.io/name: {{ include "template-base.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "template-base.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "template-base.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "template-base.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}


{{- define "recurseFlattenMap" -}}
{{- $map := first . -}}
{{- $label := last . -}}
{{- range $key, $val := $map -}}
{{ $key }}:
{{- if kindOf $val | eq "slice" -}}
{{- range $subKey, $subVal := $val -}}
\n{{ $subVal }} is an array
{{- end -}}
{{- else -}}
{{ end -}}
{{- end -}}
{{- end -}}


{{- define "template-base.accountIDAnnotation" -}}
{{- range $key, $val := $.Values.awsAccountOptions -}}
{{`{{`}}{{ printf " if eq .params.AWS_ACCOUNT_NAME" }} \"{{ printf "%s" $val.name }}\" {{`}}`}}{{ $val.id }}{{`{{ end }}`}}
{{- end }}
{{- end }}


{{- define "template-base.accountID" -}}
{{- range $key, $val := $.Values.awsAccountOptions -}}
{{`{{`}}{{ printf " if eq .params.AWS_ACCOUNT_NAME" }} "{{ printf "%s" $val.name }}" {{`}}`}}{{ $val.id }}{{`{{ end }}`}}
{{- end }}
{{- end }}
