{{- define "checkout.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "checkout.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "checkout.labels" -}}
app.kubernetes.io/name: {{ include "checkout.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "checkout.selectorLabels" -}}
app.kubernetes.io/name: {{ include "checkout.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
