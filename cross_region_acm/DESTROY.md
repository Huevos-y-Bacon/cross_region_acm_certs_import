# TF Destroy

Before destroying this, run the following otherwise destroy wiill fail (cleanup during deploy removes files):

```bash
mkdir -p tls
touch ./tls/cert.crt
touch ./tls/cert.key
touch ./tls/ca.crt
```

**ALTERNATIVELY, run:** `bash cleanup.sh`, which will do the above and run `terraform destroy`.