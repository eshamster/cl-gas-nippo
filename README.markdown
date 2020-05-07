# CL-GAS-NIPPO - A client side reindering libirary in Common Lisp

CL-GAS-NIPPO is a Google App Script to create nippo.

## Installation

At first, [Roswell](https://github.com/roswell/roswell) and [npm](https://www.npmjs.com/) are required.

1. Install clasp
   ```sh
   $ npm i @google/clasp -g
   ```
2. Login to Google
   ```sh
   $ clasp login
   ```
3. Install dependent (but not registered to quicklisp) system
   ```sh
   $ ros install eshamster/ps-experiment
   ```
4. Clone this repository
   ```sh
   $ cd ~/.roswell/local-projects/
   $ git clone https://github.com/eshamster/cl-gas-nippo.git
   ```
5. Copy configuration files and edit
   ```sh
   # Set your empty GAS project ID
   $ cp .clasp.json.in .clasp.json
   # Set your empty Google spreadsheet ID and mail addresses, and so on
   $ cp config.lisp.in config.lisp
   ```
6. Compile to a JavaScript file and push by clasp
  ```sh
  $ make push-new
  ```

## Author

* eshamster (hamgoostar@gmail.com)

## Copyright

Copyright (c) 2020 eshamster (hamgoostar@gmail.com)

## License

Licensed under the MIT License.
