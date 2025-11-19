{{- define "orders.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "orders.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "orders.labels" -}}
app.kubernetes.io/name: {{ include "orders.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "orders.selectorLabels" -}}
app.kubernetes.io/name: {{ include "orders.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
