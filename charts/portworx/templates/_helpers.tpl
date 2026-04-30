{{- define "px.getOCIImage" -}}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/oci-monitor:" (trim .Values.versions.ociMon) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/oci-monitor:" (trim .Values.versions.ociMon) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- cat "portworx/oci-monitor:" (trim .Values.versions.ociMon) | replace " " ""}}
{{- end -}}
{{- end -}}

{{- define "px.clusterName" -}}
{{- $fullClusterName := print "px-cluster-" .Values.global.clusterDomain }}
{{- (split "." $fullClusterName)._0 }}
{{- end -}}
