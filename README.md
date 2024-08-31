# I've learned Docker and try to build my own image for a Linux working environment

## 1. Build the image

Open terminal and navigate to this folder and run the command:

```pwsh
docker build --rm -f .\ubuntu.Dockerfile -t myu:dev .
```

to build the image, in which:

- `--rm` - remove intermediate containers after a successful build
- `-f` - path to the Dockerfile. In this case, it is `.\ubuntu.Dockerfile` - the Dockerfile in the current folder.
- `-t` - name of the image. In this case, it is `myu:dev`, where `myu` is the name of the image and `dev` is the tag of the image (optional).

Inspect the image:

```pwsh
docker inspect myu:dev
```

Try to reduce the layers of the image to make it smaller and more efficient if possible.

## 2. Run the container

To run the container in interactive mode (`-i`) with the name `myu` and the image `myu:dev` with the command `bash`:

```pwsh
docker run -it --name myu myu:dev bash
```

Start the container if it is stopped:

```pwsh
docker start -i myu
```

To delete the container forcefully (`-f`):

```pwsh
docker rm -f myu
```

List all containers to confirm:

```pwsh
docker ps -a
```

## 3. What's in the image?

Currently, the total size of the image is about 1.14GB including:

- Ubuntu 22.04 base image (about 72MB)

- Java 11.0.24 linux x64 (about 271MB)
  - Here I use the local compressed file from the official website to install Java, with multi-stage build, so that the compressed file is not included in the final image. The compressed file is `openjdk-11-linux-x64.tar.gz` in the `stuffs` folder.
  - The advantage is that you don't have to download from the internet every time you build the image. If you want to get update of java 11, just download the new compressed archive and overwrite *that* file in the `stuffs` folder.
  - If you want to use another version of Java (like 8 - 17 - 19 - 21 - etc) you can do the same what I did with Java 11. Or you can use the command like `apt`/`apt-get` to install Java from the repository.

- Conda base environment (about 658MB)
  - Method similar to I did with Java 11. The installation file is `Miniconda3-latest-Linux-x86_64.sh` in the `stuffs` folder.
  - To init the conda environment in bash, run the command:

    ```bash
    /opt/miniconda3/bin/conda init bash
    ```

  - It is not recommended to work with the base environment. You should create a new environment (of course take more space) with:
  
    ```bash
    conda create --name default --clone base
    ```

    and:

    ```bash
    echo "conda activate default" >> /home/son/.bashrc
    ```

    to activate the environment by default.
  - You can also add config, for example:

    ```bash
    conda config --add channels conda-forge
    ```

    to add the conda-forge channel.

- Git (about 66 MB)- with some configurations in dockerfile, modify it if you want to use your own configurations. Some steps you need to do:
  
  Generate key:

    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"

    ```

  Start the SSH agent:
  
    ```bash
    eval "$(ssh-agent -s)"
    ```

  Add your SSH private key to the agent:

    ```bash
    ssh-add ~/.ssh/id_ed25519
    ```

  Copy the SSH key to your clipboard:

    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```

  Go to GitHub, navigate to Settings > SSH and GPG keys, and click New SSH key. Paste your key and click Add SSH key.

  Using SSH for Git Operations:
  
    ```bash
    git remote set-url origin git@github.com:username/repository.git
    ```

  Replace `username` with your GitHub `username` and repository with your repository name.

  Confirm that your remote URL is set correctly:

    ```bash
    git remote -v
    ```
  
  Try pushing your changes:

    ```bash
    git push -u origin main
    ```

- Some packages: vim, openssh-client, ca-certificates (about 63 MB), add to the `ubuntu.Dockerfile` if you need more.
  
You can add or remove components to the image as needed. Rebuild the image with the same `docker build` command above to update the latest changes in the Dockerfile to the image. You also need to run the container again to apply the changes.

## 4. Next steps

- Going to setup more tools and configurations to the image.
