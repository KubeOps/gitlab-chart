{{/* ######### Gitaly related templates */}}

{{/*
Return the gitaly hostname
If the gitaly host is provided, it will use that, otherwise it will fallback
to the service name 'gitaly'. Preference is local, global, default.
*/}}
{{- define "gitlab.gitaly.host" -}}
{{- if or .Values.gitaly.host .Values.global.gitaly.host -}}
{{- coalesce .Values.gitaly.host .Values.global.gitaly.host -}}
{{- else if (coalesce .Values.gitaly.external .Values.global.gitaly.external) -}}
{{ (index (coalesce .Values.gitaly.external .Values.global.gitaly.external) .index).hostname -}}
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
{{- if coalesce .Values.gitaly.external .Values.global.gitaly.external -}}
{{- printf "%d" (index (coalesce .Values.gitaly.external .Values.global.gitaly.external) .index).port -}}
{{- else -}}
8075
{{- end -}}
{{- end -}}


{{/*
Return the gitaly storages list
*/}}
{{- define "gitlab.gitaly.storages" -}}
{{-  $d := merge (dict) . -}}
{{- $storageNames := coalesce .Values.global.gitaly.external .Values.global.gitaly.internal -}}
{{- range $i, $storage := $storageNames -}}
{{- if $d.Values.global.gitaly.external -}}
{{- printf "%s:\n" $storage.name -}}:
{{- else -}}
{{- $_ := set $d "index"  $i -}}
{{- printf "%s:\n" $storage -}}
{{- end -}}
{{- printf  "path: /var/opt/gitlab/repo\n" | indent 2 -}}
{{- printf "gitaly_address: tcp://%s:%s\n" (include "gitlab.gitaly.host" $d) (include "gitlab.gitaly.port" $d) -}}
{{- end -}}
{{- end -}}
