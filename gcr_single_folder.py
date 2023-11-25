import subprocess

def pull_and_push_images(ms_services, source_location, target_location):
    for service in ms_services:
        images = subprocess.check_output(
            ["gcrane", "ls", f"{source_location}/{service}"],
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

        # Take the 6 most recent images
        images_to_push = sorted_images[:6]

        # Iterate through pulled images and tag/push them
        for image in reversed(images_to_push):
            # Tag the pulled image
            subprocess.run(["docker", "tag", image, f"{target_location}/{service}"])

            # Push the tagged image to the target registry
            subprocess.run(["docker", "push", f"{target_location}/{service}"])

# Example usage:
# ms_services = [...]  # Fill in your list of services
# source_location = "your/source/location"
# target_location = "your/target/location"

# pull_and_push_images(ms_services, source_location, target_location)
