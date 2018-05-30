{{/* ######### Redis related templates */}}

{{/*
Return the redis hostname
If the postgresql host is provided, it will use that, otherwise it will fallback
to the service name
*/}}
{{- define "gitlab.redis.host" -}}
{{- if or .Values.redis.host .Values.global.redis.host -}}
{{- coalesce .Values.redis.host .Values.global.redis.host -}}
{{- else -}}
{{- $name := default "redis" .Values.redis.serviceName -}}
{{- printf "%s-%s" .Release.Name $name -}}
{{- end -}}
{{- end -}}

{{/*
Return the redis port
If the redis port is provided, it will use that, otherwise it will fallback
to 6379 default
*/}}
{{- define "gitlab.redis.port" -}}
{{- coalesce .Values.redis.port .Values.global.redis.port 6379 -}}
{{- end -}}

{{/*
Return the redis password secret name
*/}}
{{- define "gitlab.redis.password.secret" -}}
{{- default (printf "%s-redis-secret" .Release.Name) .Values.global.redis.password.secret | quote -}}
{{- end -}}

{{/*
Return the redis password secret key
*/}}
{{- define "gitlab.redis.password.key" -}}
{{- coalesce .Values.global.redis.password.key "secret" | quote -}}
{{- end -}}
