{{/* ######### Minio related templates */}}

{{/*
Return the minio service endpoint
*/}}
{{- define "gitlab.minio.endpoint" -}}
{{- $name := default "minio-svc" .Values.minio.serviceName -}}
{{- $port := default 9000 .Values.minio.port | int -}}
{{- printf "http://%s-%s:%d" .Release.Name $name $port -}}
{{- end -}}

{{/*
Return the minio credentials secret
*/}}
{{- define "gitlab.minio.credentials.secret" -}}
{{- default (printf "%s-minio-secret" .Release.Name) .Values.global.minio.credentials.secret | quote -}}
{{- end -}}
