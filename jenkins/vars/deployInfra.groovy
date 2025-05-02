def call(tfDir, s3Bucket, region) {
    dir(tfDir) {
        sh """
            terraform init -backend-config="bucket=${s3Bucket}" -backend-config="region=${region}"
            terraform plan -out=tfplan
            terraform apply -auto-approve tfplan
        """
    }
}
