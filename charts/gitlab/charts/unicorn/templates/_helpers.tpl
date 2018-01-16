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

{{/*
Return the db hostname
If the postgresql host is provided, it will use that, otherwise it will fallback
to the service name
*/}}
{{- define "unicorn.psql.host" -}}
{{- if .Values.psql.host -}}
{{- .Values.psql.host | quote -}}
{{- else -}}
{{- $name := default "omnibus" .Values.psql.serviceName -}}
{{- printf "%s-%s" .Release.Name $name -}}
{{- end -}}
{{- end -}}

{{/*
Return the redis hostname
If the redis host is provided, it will use that, otherwise it will fallback
to the service name
*/}}
{{- define "unicorn.redis.host" -}}
{{- if .Values.redis.host -}}
{{- .Values.redis.host -}}
{{- else -}}
{{- $name := default "redis" .Values.redis.serviceName -}}
{{- printf "%s-%s" .Release.Name $name -}}
{{- end -}}
{{- end -}}

{{/*
Return the gitaly hostname
If the gitaly host is provided, it will use that, otherwise it will fallback
to the service name
*/}}
{{- define "unicorn.gitaly.host" -}}
{{- if .Values.gitaly.host -}}
{{- .Values.gitaly.host -}}
{{- else -}}
{{- $name := default "gitaly" .Values.gitaly.serviceName -}}
{{- printf "%s-%s" .Release.Name $name -}}
{{- end -}}
{{- end -}}

{{/*
Return the registry api hostname
If the registry api host is provided, it will use that, otherwise it will fallback
to the service name
*/}}
{{- define "unicorn.registry.api.host" -}}
{{-   if .Values.registry.api.host -}}
{{-     .Values.registry.api.host -}}
{{-   else -}}
{{-     $name := default .Values.global.hosts.registry.serviceName .Values.registry.api.serviceName -}}
{{-     printf "%s-%s" .Release.Name $name -}}
{{-   end -}}
{{- end -}}

{{/*
Return the registry external hostname
If the chart registry host is provided, it will use that, otherwise it will fallback
to the global registr host name.
*/}}
{{- define "unicorn.registry.host" -}}
{{-   if .Values.registry.host -}}
{{-     .Values.registry.host -}}
{{-   else -}}
{{-     template "registryHost" . -}}
{{-   end -}}
{{- end -}}

{{- define "assembleHost" -}}
{{- $name := .name -}}
{{- $context := .context -}}
{{- $result := dict -}}
{{- if $context.Values.global.hosts.domain -}}
{{-   $_ := set $result "domainHost" (printf ".%s" $context.Values.global.hosts.domain) -}}
{{-   if $context.Values.global.hosts.hostSuffix -}}
{{-     $_ := set $result "domainHost" (printf "-%s%s" $context.Values.global.hosts.hostSuffix $result.domainHost) -}}
{{-   end -}}
{{-   $_ := set $result "domainHost" (printf "%s%s" $name $result.domainHost) -}}
{{- end -}}
{{- $result.domainHost -}}
{{- end -}}

{{- define "gitlabHost" -}}
{{- coalesce .Values.global.hosts.gitlab.name (include "assembleHost"  (dict "name" "gitlab" "context" . )) -}}
{{- end -}}

{{- define "gitlabUrl" -}}
{{- if or .Values.global.hosts.https .Values.global.hosts.gitlab.https -}}
{{-   printf "https://%s" (include "gitlabHost" .) -}}
{{- else -}}
{{-   printf "http://%s" (include "gitlabHost" .) -}}
{{- end -}}
{{- end -}}

{{- define "registryHost" -}}
{{- coalesce .Values.registry.host .Values.global.hosts.registry.name (include "assembleHost"  (dict "name" "registry" "context" . )) -}}
{{- end -}}
