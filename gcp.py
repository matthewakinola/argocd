import subprocess

def migrate_images(ms_services, source_location, target_location):
    for service in ms_services:
        folders = subprocess.check_output(
            ["gcrane", "ls", f"{source_location}/{service}"],
            text=True
        ).splitlines()

        # Checks if there's any image in the folder
        folders = [folder for folder in folders if "@sha256" not in folder]
        folders = [folder for folder in folders if ":" not in folder]
        
        for folder in folders:
            # Get the list of images in the subfolder
            images = subprocess.check_output(
                ["gcrane", "ls", f"{folder}"],
                text=True
            ).splitlines()
            
            pulled_images = []
            try:
                for image in images:
                    # Pull the image without the digest reference
                    subprocess.run(["docker", "pull", f"{image}"])

                    # Append the image to the pulled_images list
                    pulled_images.append(image)
            except subprocess.CalledProcessError as e:
                pass
            
            # Sort the pulled images by timestamp in descending order
            sorted_images = sorted(pulled_images, key=lambda x: x.split(":")[-1], reverse=True)

            # Take the 5 most recent images
            images_to_push = sorted_images[:6]

            # Iterate through pulled images and tag/push them
            for image in reversed(images_to_push):
                name_format = folder.split("@")[0].split("/")[-2:]
                name_format = "/".join(name_format)

                # Tag the pulled image
                subprocess.run(["docker", "tag", image, f"{target_location}/{name_format}"])

                # Push the tagged image to the target registry
                subprocess.run(["docker", "push", f"{target_location}/{name_format}"])

# # Example usage:
# ms_services = [...]  # Fill in your list of services
# source_location = "your/source/location"
# target_location = "your/target/location"

# migrate_images(ms_services, source_location, target_location)
