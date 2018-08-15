{{- define "gitlab.application.labels" -}}
app.kubernetes.io/name: {{ .Values.global.application.name }}
{{- end -}}

# Default labels include the immutable labels, and the mutable labels.
{{- define "gitlab.standardLabels" -}}
{{ template "gitlab.immutableLabels" . }}
{{ template "gitlab.mutableLabels" . }}
{{- end -}}

# Labels that won't change across new versions of the release.
# TODO: Validate that `template "name" .` won't ever change in a release.
{{- define "gitlab.immutableLabels" -}}
app: {{ template "name" . }}
chart: {{ .Chart.Name }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

# Defines labels that may change, and won't break selectors in the process of changing
{{- define "gitlab.mutableLabels" -}}
version: {{ .Chart.Version | replace "+" "_" }}
{{ if .Values.global.application.name -}}
{{ include "gitlab.application.labels" . }}
{{- end -}}
{{- end -}}
