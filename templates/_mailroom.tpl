{{/* ######### GitLab related templates */}}

{{/*
Return the incoming email password secret name
*/}}
{{- define "gitlab.incomingEmail.password.secret" -}}
{{- default (printf "%s-gitlab-incoming-email-password" .Release.Name) .Values.global.appConfig.incomingEmail.password.secret | quote -}}
{{- end -}}

{{/*
Return the incoming email password secret key
*/}}
{{- define "gitlab.incomingEmail.password.key" -}}
{{- coalesce .Values.global.appConfig.incomingEmail.password.key "password" | quote -}}
{{- end -}}
