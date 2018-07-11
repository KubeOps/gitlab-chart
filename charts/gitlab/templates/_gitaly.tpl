{{/* ######### Gitaly related templates */}}

{{/*
Return the gitaly hostname
If the gitaly host is provided, it will use that, otherwise it will fallback
to the service name 'gitaly'. Preference is local, global, default.
*/}}
{{- define "gitlab.gitaly.host" }}
{{- if .Values.gitaly.nodes -}}
{{- if (index .Values.gitaly.nodes .index).hostname -}}
{{ (index .Values.gitaly.nodes .index).hostname -}}
{{- end }}
{{- else if .Values.global.gitaly.nodes -}}
{{- if (index .Values.global.gitaly.nodes .index).hostname -}}
{{ (index .Values.global.gitaly.nodes .index).hostname }}
{{- end }}
{{- else -}}
{{- $podName := printf "%s-gitaly-%d" .Release.Name .index }}
{{- $name := coalesce .Values.gitaly.serviceName .Values.global.gitaly.serviceName "gitaly" }}
{{- printf "%s.%s-%s" $podName .Release.Name $name }}
{{- end }}
{{- end }}


{{/*
Return the gitaly port
Preference is local, global, default (`8075`)
*/}}
{{- define "gitlab.gitaly.port" }}
{{- if .Values.gitaly.nodes -}}
{{- if (index .Values.gitaly.nodes .index).port -}}
{{ (index .Values.gitaly.nodes .index).port }}
{{- end }}
{{- else if .Values.global.gitaly.nodes -}}
{{- if (index .Values.global.gitaly.nodes .index).port -}}
{{ (index .Values.global.gitaly.nodes .index).port }}
{{- end }}
{{- else -}}
8075
{{- end -}}
{{- end }}
