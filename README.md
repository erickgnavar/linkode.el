# linkode.el

Send buffer or region code to linkode.org to generate an image.

## Installation

### Cloning the repo

Clone this repo somewhere

Add this to your config

```elisp
(add-to-list 'load-path "path where the repo was cloned")

(require 'linkode)
```

### Using use-package and quelpa

```elisp
(use-package linkode
  :ensure t
  :quelpa (linkode :fetcher github :repo "erickgnavar/linkode.el"))
```

## Usage

`M-x linkode-region` to use the selected region

`M-x linkode-buffer` to use the buffer content

The code will be send to [linkode](http://linkode.org) and the resulting link will be copied to the clipboard
