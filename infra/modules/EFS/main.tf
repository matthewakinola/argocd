
# create key from key management system
resource "aws_kms_key" "k8s_kms" {
  description = "KMS key "
  policy      = <<EOF
  {
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${local.secret_map["account_no"]}:user/techmatt" },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# create key alias
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.k8s_kms.key_id
}

# create Elastic file system
resource "aws_efs_file_system" "k8s_efs" {
  
  encrypted  = true
  kms_key_id = aws_kms_key.k8s_kms.arn

tags = {
    Name = "django-k8s-file-system"
    }

}


resource "aws_efs_mount_target" "mount-target" {
    file_system_id = aws_efs_file_system.k8s_efs.id
    subnet_id = each.key
    for_each = toset(var.efs_subnets)
    security_groups = var.efs_sg
}


# create access point for tooling
resource "aws_efs_access_point" "django-k8s-access-point" {
  file_system_id = aws_efs_file_system.k8s_efs.id
  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {

    path = "/"
    
    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }

  }
}
