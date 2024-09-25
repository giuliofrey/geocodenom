# Geocode Addresses in Stata


## Overview

`geocode.ado` is a Stata program designed to geocode addresses using the Nominatim API. It adds latitude and longitude coordinates to your dataset based on address information.

## Requirements

- Stata with internet access
- `jsonio` package for handling JSON data
- `curl` command-line tool

## Installation

1. **Install the `jsonio` package**:
    ```stata
    ssc install jsonio
    ```

2. **Ensure `curl` is installed**:
    - For Windows: Download and install from [curl official website](https://curl.se/windows/).
    - For macOS: Use Homebrew:
        ```bash
        brew install curl
        ```
    - For Linux: Use the package manager for your distribution (e.g., `apt-get install curl` for Debian-based systems).

3. **Save the ADO file**:
    - Save the `geocode.ado` script in your Stata ADO directory. You can find the directory by running `adopath` in Stata.

## Usage

1. **Load your dataset**:
    ```stata
    use your_dataset.dta, clear
    ```

2. **Run the `geocode` command**:
    ```stata
    geocode address_var, save(geocoded_dataset.dta)
    ```

    - `address_var`: The variable in your dataset containing the addresses to be geocoded.
    - `save(string)`: The name of the output dataset to save the geocoded data.

### Example

```stata
* Load your dataset
use your_dataset.dta, clear

* Perform geocoding
geocode address, save(geocoded_dataset.dta)
```

## Details

- The `geocode` program will create two new variables in your dataset: `latitude` and `longitude`.
- The program loops over each observation, sends the address to the Nominatim API, and parses the returned JSON response to extract latitude and longitude.
- The geocoded data is saved to the specified output file.

## Notes

- Ensure compliance with Nominatim’s usage policy and rate limits.
- Consider adding delays between requests for large datasets to avoid hitting rate limits.
- Basic error handling is included; further enhancements can be made to handle various edge cases and improve robustness.

## Support

For issues or questions, please contact the maintainer of this ADO file or consult Stata's online resources and forums for additional help.



