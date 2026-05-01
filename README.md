# f5c

Source-built container for `f5c`.

## Quick Usage

```bash
docker pull docker.io/picotainers/f5c:latest
docker run --rm docker.io/picotainers/f5c:latest --help
```

## Usage

```bash
# Example: eventalign command (requires your FASTQ/BAM/index files)
docker run --rm -v "$(pwd):/data" -w /data docker.io/picotainers/f5c:latest eventalign --help
```

## Building

```bash
docker build -t docker.io/picotainers/f5c:latest .
```
