import os

# Define the folder structure as a nested dictionary
structure = {
    "lib": {
        "core": {
            "utils": {},
            "usecases": {},
            "errors": {}
        },
        "features": {
            "home": {
                "data": {
                    "entities": {
                        "remote": {},
                        "local": {}
                    },
                    "models": {
                        "remote": {},
                        "local": {}
                    },
                    "repo": {}
                },
                "domain": {
                    "entities": {},
                    "usecases": {},
                    "repo": {}
                },
                "presentation": {
                    "screens": {},
                    "blocs": {
                        "blocs": {},
                        "cubits": {}
                    }
                }
            }
        },
        "routes": {}
    }
}

def create_folders(base_path, folder_dict):
    """Recursively create folders from a dictionary definition."""
    for folder, subfolders in folder_dict.items():
        new_path = os.path.join(base_path, folder)
        os.makedirs(new_path, exist_ok=True)
        if isinstance(subfolders, dict):
            create_folders(new_path, subfolders)

base_directory = os.getcwd()  # Current directory
create_folders(base_directory, structure)
print("✅ Clean Architecture folder structure created successfully!")
