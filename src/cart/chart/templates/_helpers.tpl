{{- define "cart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "cart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cart.labels" -}}
app.kubernetes.io/name: {{ include "cart.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "cart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
