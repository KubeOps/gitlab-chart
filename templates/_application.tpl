{{- define "gitlab.application.labels" -}}
app.kubernetes.io/name: {{ .Values.global.application.name | quote }}
{{- end -}}

# Default labels include the immutable labels, and the mutable labels.
{{- define "gitlab.standardLabels" -}}
{{ template "gitlab.immutableLabels" . }}
{{ template "gitlab.mutableLabels" . }}
{{- end -}}

{{-
 /**
  * Pod selectors for some application in some release.
  *
  * This template selects ALL pods in the chart which are labeled using the templates in this file. If you're using
  *  multiple sets of pods (via e.g. jobs, statefulSets, deployments, etc.) you MUST add your own labels to the
  *  selector, or otherwise you will have conflicting selectors, which will result in potentially broken applications
  *  and degraded performance accross the whole cluster.
  * For more information, see https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors
  *
  * WARNING: the content of these may never ever change in a apps/v1beta1+ resource. If `template "name" . ` ever
  *  changes format in this context, that WILL break the selectors which depend on this behaviour.
  *
  * DEPRECATED: in favor of "gitlab.immutableLabels". When a resource of api version apps/v1beta2+ is to be replaced
  *  completely, you should update the template to "gitlab.immutableLabels".
  *
  * NOTE: these values are quoted using `quote` instead of manual quoting: this should disallow any form of unsafe
  *  template value injection via the "name" template or the .Release.Name field's value, and fail if such behaviour is
  *  tried.
  */
-}}
{{- define "gitlab._depr_podSelectorLabels" -}}
app: {{ template "name" . | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{-
 /**
  * Labels that won't change across new versions of the release.
  *
  * This template selects ALL pods in the chart which are labeled using the templates in this file. If you're using
  *  multiple sets of pods (via e.g. jobs, statefulSets, deployments, etc.) you MUST add your own labels to the
  *  selector, or otherwise you will have conflicting selectors, which will result in potentially broken applications
  *  and degraded performance accross the whole cluster.
  * For more information, see https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors
  *
  * WARNING: the content of these may never ever change in a apps/v1beta1+ resource. If `template "name" . ` ever
  *  changes format in this context, that WILL break the selectors which depend on this behaviour.
  *
  * NOTE: these values are quoted using `quote` instead of manual quoting: this should disallow any form of unsafe
  *  template value injection via the "name" template or the .Release.Name field's value, and fail if such behaviour is
  *  tried.
  */
-}}
{{- define "gitlab.immutableLabels" -}}
{{ template "gitlab._depr_podSelectorLabels" . }}
chart: {{ .Chart.Name | quote }}
heritage: {{ .Release.Service | quote }}
{{- end -}}

{{-
 /**
  * Defines labels that may change, and won't break selectors in the process of changing
  */
-}}
{{- define "gitlab.mutableLabels" -}}
version: {{ .Chart.Version | replace "+" "_" }}
{{ if .Values.global.application.name -}}
{{ include "gitlab.application.labels" . }}
{{- end -}}
{{- end -}}
