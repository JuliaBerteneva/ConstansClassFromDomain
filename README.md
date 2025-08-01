# ZCC_GENERATE_CLASS

ABAP report that generates a constants class based on fixed values of a domain.

## Why

Hardcoding domain values in ABAP code is a maintenance nightmare. When values change, it's hard to trace where they're used. Encapsulating those values in a constants class makes the code safer and more readable—but writing such classes manually is tedious.

This report automates that.

## What It Does

Given a data element, the report:

- Extracts the domain from it
- Reads all fixed values of the domain
- Generates an ABAP class with constant definitions
- Uses the data element to ensure proper type alignment

## Features

- ✅ Class name auto-generated using a custom rule with support for `[D]` token (domain name)
- ✅ Option to skip overwrite check if regenerating an existing class
- ✅ Automatically assigns transport and package based on domain metadata
- ✅ Uses `SEO_CLASS_CREATE_COMPLETE` to generate class definitions
- ✅ Based on CDS views to simplify lookups

## Selection Screen

![image.png](attachment:ca379489-6651-4b54-8d40-80c0bc36f9d0:image.png)

*Example UI with 3 fields:*

- **Data Element**: The element whose domain is used to extract fixed values and determine the type of each constant.
- **New Class Naming Rule**: A string pattern to define the name of the generated class. Use `[D]` to insert the domain name.
- **Regenerate Existing Class**: If checked, skips the existence check and allows the class to be overwritten.

## Installation

1. Import the report `ZCC_GENERATE_CLASS` into your system.
2. Make sure the required CDS views are active (see below).
3. Run the report from SE38/SA38 or add it to a custom transaction if desired.

## CDS Views Used

This project relies on several CDS views to fetch domain metadata, data element definitions, transport info, and package assignments. You’ll find the source code for each CDS view in the `cds_views/` directory.

zcc_i_data_element_domain - retrives domain name for given data element

zcc_i_domain_package - retrieve package, where domain is located in

zcc_i_domain_transport - get transport, where domain is located in

zcc_i_domain_values - get list of domain values

## Example

If the domain `ZMY_DOMAIN` contains:

```
01 | LOW
02 | MEDIUM
03 | HIGH
```

Running the report with appropriate settings will generate a class like

```abap
CLASS zcl_zmy_domain_constants DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CONSTANTS: gc_low    TYPE zmy_data_element VALUE '01',
               gc_medium TYPE zmy_data_element VALUE '02',
               gc_high   TYPE zmy_data_element VALUE '03'.
ENDCLASS.
```

## Notes

- The class is created in the same transport and package as the original domain.
- If you modify the domain (e.g. add/remove a value), just re-run the report with the checkbox enabled to update the class.
