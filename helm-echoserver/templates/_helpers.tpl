{{/* Generate basic labels */}}
{{- define "helm-echoserver-chart.labels" }}
  generator: helm
  date: {{ now | htmlDate | quote }}
  chart: {{ .Chart.Name }}
  version: {{ .Chart.Version }}
  app_name: {{ .Chart.Name }}
  app_version: {{ .Values.Image.Tag | quote }}
  release: {{ .Release.Name }}
  heritage: {{ .Release.Service }}
{{- end }}

{{- define "app-unique-selector-label" -}}
  app: {{ .Release.Name }}-{{ .Release.Time.Seconds }}
{{- end -}}
