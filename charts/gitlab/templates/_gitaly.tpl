{{/* ######### Gitaly related templates */}}

{{/*
Return gitaly host for internal statefulsets
*/}}
{{- define "gitlab.gitaly.storage.internal" -}}
{{- $releaseName := .Release.Name -}}
{{- $name := coalesce .Values.gitaly.serviceName .Values.global.gitaly.serviceName "gitaly" -}}
{{- range $i, $storage := .Values.global.gitaly.internal -}}
{{- printf "%s:\n" $storage -}}
{{- printf  "path: /var/opt/gitlab/repo\n" | indent 2 -}}
{{- $podName := printf "%s-gitaly-%d" $releaseName $i -}}
{{- printf "gitaly_address: tcp://%s.%s-%s:%d\n" $podName $releaseName $name 8075 -}}
{{- end -}}
{{- end -}}


{{/*
Return gitaly storage for external hosts
*/}}
{{- define "gitlab.gitaly.storage.external" -}}
{{- range $i, $storage := .Values.global.gitaly.external -}}
{{- printf "%s:\n" $storage.name -}}
{{- printf  "path: /var/opt/gitlab/repo\n" | indent 2 -}}
{{- printf "gitaly_address: tcp://%s:%v\n" $storage.hostname $storage.port -}}
{{- end -}}
{{- end -}}


{{/*
Return the gitaly storages list
*/}}
{{- define "gitlab.gitaly.storages" -}}
{{- if .Values.global.gitaly.host -}}
default:
  path: /var/opt/gitlab/repo
  gitaly_addres: {{ printf "tcp://%s:%d" .Values.global.gitaly.host (default .Values.global.gitaly.port 8075) }}
{{- else -}}
{{- if .Values.global.gitaly.external -}}
{{ template "gitlab.gitaly.storage.external" . }}
{{- end -}}
{{- if .Values.global.gitaly.internal -}}
{{ template "gitlab.gitaly.storage.internal" . }}
{{- end -}}
{{- end -}}
{{- end -}}
