# cross_region_acm_certs_import

Example/POC for generating a dummy CA and cert, upload to S3, use TF to download from S3 and deploy ACM certs to `eu-west-1` and `us-east-1` regions (latter for CloudFront)

## Deploy

*Note: all state files for this example are local*

1. *update script to suit your needs*
2. run `./gen_certs.sh`
3. deploy `certs_bucket` *(tf)*
4. deploy `cross_region_acm` *(tf)*

---
## Cleanup

1. destroy cross_region_acm *(tf)*
2. destroy certs_bucket *(tf)*
3. delete tls folders: `find . -type d -name tls -exec rm -rf {} \;`
4. remove state and backup: `find . -type f -iname "terraform.tfstate*" -delete`
5. remove .terraform*: `find . -name ".terraform*" -exec rm -rf {} \;`

**3-5:**
```bash
find . -type d -name tls -exec rm -rf {} \;
find . -type f -iname "terraform.tfstate*" -delete
find . -name ".terraform*" -exec rm -rf {} \;
```