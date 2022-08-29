#!/bin/bash
# This scripts generates the flux manifests for installations
WORKDIR=/tmp
CHART_DIR=../charts
CHART_NAME=template-base

mkdir -p $WORKDIR/flux

flux install --components-extra=image-reflector-controller,image-automation-controller --export > $WORKDIR/flux/manifests.yaml
cp flux-install-patch.yaml $WORKDIR/flux/kustomization.yaml
kustomize build $WORKDIR/flux > $WORKDIR/flux/patched-manifests.yaml
kubectl create configmap --dry-run '{{`{{ .params.CLUSTER_NAME }}`}}-flux-manifests' -o yaml --from-file=manifests.yaml=$WORKDIR/flux/patched-manifests.yaml > $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml


## Format file for capi template array
sed 's_^_  _' $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml > $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml.tmp
mv $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml.tmp $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml

sed '1s/.*/- apiVersion: v1/' $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml > $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml.tmp
mv $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml.tmp $CHART_DIR/$CHART_NAME/files/flux-install-manifests.yaml
