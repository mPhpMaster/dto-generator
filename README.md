# DTO Generator

A simple Bash script to generate Data Transfer Object (DTO) files. The script allows you to specify the namespace, model name, and directory for your DTO files, and optionally create a base DTO class.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Options](#options)
- [Arguments](#arguments)
- [Examples](#examples)
- [License](#license)

## Installation

### Using Composer

To install the script globally using Composer, run:

```bash
composer global require mPhpMaster/dto-generator
```

### Manual Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/mPhpMaster/dto-generator.git
    ```

2. Make the script executable:

    ```bash
    chmod +x dto.sh
    ```

3. Move the script to a directory in your PATH, for example:

    ```bash
    sudo mv dto.sh /usr/local/bin/dto
    ```

## Usage

To generate a DTO file, use the following command:

```bash
dto [options] [model]
```

### Options

- `-h`, `--help`: Show this help message.
- `--namespace=<ns>`: Optional namespace (default is empty).
- `-B`, `--base`: Create `BaseDTO.php`.
- `-f`, `--force`: Force overwrite of existing files.
- `--dir=<dir>`: Directory to create (default is `app/DataTransferObjects`).

### Arguments

- `model`: Model name (default is `UserDTO`).

### Examples

#### Generate a DTO with Default Settings

```bash
dto
```

This will generate a `UserDTO.php` in the `app/DataTransferObjects` directory with no namespace.

#### Generate a DTO with a Custom Model Name

```bash
dto MyModel
```

This will generate `MyModel.php` in the `app/DataTransferObjects` directory.

#### Generate a DTO with a Namespace

```bash
dto --namespace=App\\DTO MyModel
```

This will generate `MyModel.php` in the `app/DataTransferObjects` directory with the namespace `App\DTO`.

#### Create a Base DTO Class

```bash
dto --base
```

This will create a `BaseDTO.php` file in the `app/DataTransferObjects` directory.

#### Specify a Different Directory

```bash
dto --dir=src/DTO MyModel
```

This will generate `MyModel.php` in the `src/DTO` directory.

#### Force Overwrite Existing Files

```bash
dto --force MyModel
```

This will overwrite `MyModel.php` if it already exists.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
