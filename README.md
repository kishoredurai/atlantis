# Installing Atlantis using Helm Chart

### Required
- Install eksctl
- helm

---


### Files

`atlantis.yaml` -  project configuration for atlantis

`atlantis-value.yml` - Helm values for atlantis

---


### Create cluster using eksctl

```
eksctl create cluster -f cluster.yaml
```

###  CSI driver installation
A PersistentVolume will be required for Atlantis to manage local state.

- Enable IAM OIDC provider:
  ```
  eksctl utils associate-iam-oidc-provider --region=<Your_Region> --cluster=<Your_ClusterName> --approve
  ```

- Create a Service Account for the Amazon EBS CSI driver role:
  ```
   eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster atlantis-cluster \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --region us-east-1 \
  --role-name AmazonEKS_EBS_CSI_DriverRole
  ```
- Add the Amazon EBS CSI add-on:
  ```
  eksctl create addon --name aws-ebs-csi-driver --cluster atlantis-cluster --region us-east-1 --service-account-role-arn arn:aws:iam::<accountid>:role/AmazonEKS_EBS_CSI_DriverRole --force
  ```

### Helm Chart

We will use the official helm chart to install Atlantis on an AWS EKS cluster.


```
helm repo add runatlantis https://runatlantis.github.io/helm-charts
```

```
git clone https://github.com/kishoredurai/atlantis.git
```

Update github credential values in `atlantis-value.yml`



```
helm upgrade -i atlantis runatlantis/atlantis -f atlantis-values.yaml
```

### Deployment
the Atlantis server is exposed as a load balancer

```
kubectl get svc --namespace default atlantis -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```


### Github app

To integrate github app with atlantis just add below code to `atlantis-value.yml`

```yaml
    # Github App integration
        - name: ATLANTIS_GH_APP_ID
          valueFrom:
            secretKeyRef:
              name: atlantis-github-app
              key: ghAppID
        - name: ATLANTIS_GH_APP_KEY
          valueFrom:
            secretKeyRef:
              name: atlantis-github-app
              key: ghAppKey
        - name: ATLANTIS_GH_WEBHOOK_SECRET
          valueFrom:
            secretKeyRef:
              name: atlantis-github-app
              key: ghWebhookSecret
```

