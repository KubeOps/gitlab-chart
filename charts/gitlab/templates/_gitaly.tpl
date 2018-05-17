{{/* ######### Gitaly related templates */}}

{{/*
Return the gitaly hostname
If the gitaly host is provided, it will use that, otherwise it will fallback
to the service name 'gitaly'
*/}}
{{- define "gitlab.gitaly.host" -}}
{{- if or .Values.gitaly.host .Values.global.gitaly.host -}}
{{- coalesce .Values.global.gitaly.host .Values.gitaly.host -}}
{{- else -}}
{{- $podName := printf "%s-gitaly-0" .Release.Name -}}
{{- $name := default "gitaly" .Values.gitaly.serviceName -}}
{{- printf "%s.%s-%s" $podName .Release.Name $name -}}
{{- end -}}
{{- end -}}

{{/*
Return the gitaly port
If the gitaly port is provided, it will use that, otherwise it will fallback
to the default of 8075
*/}}
{{- define "gitlab.gitaly.port" -}}
{{- coalesce .Values.gitaly.port .Values.global.gitaly.port 8075 -}}
{{- end -}}

{{/*
Return the gitaly secret name
Preference is global, local, default (`gitaly-secret`)
*/}}
{{- define "gitlab.gitaly.authToken.secret" -}}
{{- coalesce .Values.global.gitaly.authToken.secret .Values.gitaly.authToken.secret "gitaly-secret" | quote -}}
{{- end -}}

{{/*
Return the gitaly secret name
Preference is global, local, default (`token`)
*/}}
{{- define "gitlab.gitaly.authToken.key" -}}
{{- coalesce .Values.global.gitaly.authToken.key .Values.gitaly.authToken.key "token" | quote -}}
{{- end -}}
