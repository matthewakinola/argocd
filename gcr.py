import subprocess

#list of the folders to copy the images from
folders = []

#location and rhe project of the source repository
source_location = "eu.gcr.io/admin-roava-io/roava.io/service"

#location and the project of the target repository
#target_location = "europe-docker.pkg.dev/admin-roava-io/eu-gcr.io"
target_location = "eu.gcr.io/admin-roava-io/roava.io/service"

for folder in folders:
    images = subprocess.check_output(
        ["gcrane", "ls", f"{source_location}/{folder}"], 
        text=True
        ).splitlines()
    
    #sort the images basesed on their creation time
    images.sort(
        key=lambda image: subprocess.check_output([
            "docker", "image", "history", "--format", 
            "{{.Created}}", f"{source_location}/{folder}/{image}"
            ],
            text=True
        ))

    #copy the recent 10 images to the target repository
    for image in images[:10]:
        subprocess.run([
            "gcrane", "cp", f"{source_location}/{folder}/{image}", 
            f"{target_location}/{folder}/{image}"
        ])
