# linkode.el

Send buffer or region code to linkode.org to generate an image.

## Installation

Clone this repo somewhere

Add this to your config

```elisp
(add-to-list 'load-path "path where the repo was cloned")

(require 'linkode)
```

## Usage

`M-x linkode-send-region` to use the selected region

`M-x linkode-send-buffer` to use the buffer content

The code will be send to [linkode](http://linkode.org) and the resulting link will be copied to the clipboard
