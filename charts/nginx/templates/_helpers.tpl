{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "global.hostname" -}}
{{- $proto, $host := splitList "://" . -}}
{{- $host -}}
{{- end -}}

{{- define "global.hostprotocol" -}}
{{- $proto, $host := splitList "://" . -}}
{{- printf "$s://" $proto -}}
{{- end -}}

{{/*
Return the serviceaccount name
*/}}
{{- define "nginx.serviceAccountName" -}}
{{- if .Values.serviceAccount.autoGenerate -}}
{{- template "fullname" . -}}
{{- else -}}
{{- .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
