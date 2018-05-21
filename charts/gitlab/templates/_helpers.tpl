{{/* vim: set filetype=mustache: */}}
{{/*
Returns the GitLab Url, ex: `http://gitlab.example.local`
If `global.hosts.https` or `global.hosts.gitlab.https` is true, it uses https, otherwise http.
Calls into the `gitlab.gitlabHost` function for the hostname part of the url.
*/}}
{{- define "gitlabUrl" -}}
{{- if or .Values.global.hosts.https .Values.global.hosts.gitlab.https -}}
{{-   printf "https://%s" (include "gitlab.gitlabHost" .) -}}
{{- else -}}
{{-   printf "http://%s" (include "gitlab.gitlabHost" .) -}}
{{- end -}}
{{- end -}}
