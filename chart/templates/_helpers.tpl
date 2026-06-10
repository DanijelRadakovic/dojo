{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper Dojo image name
*/}}
{{- define "dojo.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "dojo.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" $) -}}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "dojo.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "dojo.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Dojo - Incorrect extra volume settings */}}
{{- define "dojo.validateValues.extraVolumes" -}}
{{- if and (.Values.extraVolumes) (not (or .Values.extraVolumeMounts .Values.sidecars)) -}}
dojo: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value or use them in sidecars
{{- end -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "dojo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
