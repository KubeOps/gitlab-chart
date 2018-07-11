{{/* ######### Gitaly related templates */}}

{{/*
Return the gitaly hostname
If the gitaly host is provided, it will use that, otherwise it will fallback
to the service name 'gitaly'. Preference is local, global, default.
*/}}
{{- define "gitlab.gitaly.host" -}}
{{- if .Values.gitaly.hosts }}
{{- index .Values.gitaly.hosts .index }}
{{- else if .Values.global.gitaly.hosts -}}
{{- index .Values.global.gitaly.hosts .index}}
{{- else -}}
{{- $podName := printf "%s-gitaly-%d" .Release.Name .index -}}
{{- $name := coalesce .Values.gitaly.serviceName .Values.global.gitaly.serviceName "gitaly" -}}
{{- printf "%s.%s-%s" $podName .Release.Name $name -}}
{{- end -}}
{{- end -}}

{{/*
Return the gitaly port
Preference is local, global, default (`8075`)
*/}}
{{- define "gitlab.gitaly.port" -}}
{{- if .Values.gitaly.ports -}}
{{ index .Values.gitaly.ports .index }}
{{- else if .Values.global.gitaly.ports -}}
{{ index .Values.global.gitaly.ports .index }}
{{- else -}}
8075
{{- end -}}
{{- end -}}
