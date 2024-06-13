# SPDX-License-Identifier: Apache-2.0
# Copyright 2022 The HuggingFace Authors.

{{- define "envCommon" -}}
- name: COMMON_BLOCKED_DATASETS
  value: {{ .Values.common.blockedDatasets | quote}}
- name: COMMON_DATASET_SCRIPTS_ALLOW_LIST
  value: {{ .Values.common.datasetScriptsAllowList | quote}}
- name: COMMON_HF_ENDPOINT
  value: {{ include "datasetsServer.hub.url" . }}
- name: HF_ENDPOINT # see https://github.com/huggingface/datasets/pull/5196#issuecomment-1322191411
  value: {{ include "datasetsServer.hub.url" . }}
- name: COMMON_HF_TOKEN
  {{- if .Values.secrets.appHfToken.fromSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.appHfToken.secretName | default (include "datasetsServer.infisical.secretName" $) | quote }}
      key: HF_TOKEN
      optional: false
  {{- else }}
  value: {{ .Values.secrets.appHfToken.value }}
  {{- end }}
{{- end -}}

{{- define "datasetServer.mongo.url" -}}
{{- if .Values.secrets.mongoUrl.fromSecret }}
valueFrom:
  secretKeyRef:
    name: {{ .Values.secrets.mongoUrl.secretName | default (include "datasetsServer.infisical.secretName" $) | quote }}
    key: MONGO_URL
    optional: false
{{- else }}
  {{- if .Values.mongodb.enabled }}
value: mongodb://{{.Release.Name}}-datasets-server-mongodb
  {{- else }}
value: {{ .Values.secrets.mongoUrl.value }}
  {{- end }}
{{- end }}
{{- end -}}
