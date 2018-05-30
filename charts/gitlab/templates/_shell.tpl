{{/*
Return the gitlab-shell authToken secret name
*/}}
{{- define "gitlab.gitlab-shell.authToken.secret" -}}
{{- default (printf "%s-gitlab-shell-secret" .Release.Name) .Values.global.shell.authToken.secret | quote -}}
{{- end -}}

{{/*
Return the gitlab-shell authToken secret key
*/}}
{{- define "gitlab.gitlab-shell.authToken.key" -}}
{{- coalesce .Values.global.shell.authToken.key "secret" | quote -}}
{{- end -}}
