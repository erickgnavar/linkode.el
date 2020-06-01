;;; linkode.el --- Generate a linkode snippet with region/buffer content

;; Copyright © 2018 Erick Navarro
;; Author: Erick Navarro <erick@navarro.io>
;; URL: https://github.com/erickgnavar/linkode.el
;; Version: 0.1.0

;;; Commentary:
;; Just send the selected code to linkode website

;;; Code:

(defconst linkode--url "http://linkode.org/api/1/linkodes/")

(defconst linkode--supported-modes '((fundamental-mode . "auto")
                                     (auto-mode . "plain text")
                                     (c-mode . "c")
                                     (csharp-mode . "c#")
                                     (c++-mode . "c++")
                                     (clojure-mode . "clojure")
                                     (coffeescript-mode . "coffeescript")
                                     (css-mode . "css")
                                     (d-mode . "d")
                                     (diff-mode . "diff")
                                     (erlang-mode . "erlang")
                                     (go-mode . "go")
                                     (groovy-mode . "groovy")
                                     (haskell-mode . "haskell")
                                     (html-mode . "html")
                                     (web-mode . "htmlmixed")
                                     (java-mode . "java")
                                     (javascript-mode . "javascript")
                                     (json-mode . "json")
                                     (less-mode . "less")
                                     (lua-mode . "lua")
                                     (markdown-mode . "markdown")
                                     (nginx-mode . "nginx")
                                     (perl-mode . "perl")
                                     (php-mode . "php")
                                     (python-mode . "python")
                                     (r-mode . "r")
                                     (ruby-mode . "ruby")
                                     (scala-mode . "scala")
                                     (shell-mode . "shell")
                                     (sql-mode . "sql")
                                     (typescript-mode . "typescript")
                                     (xml-mode . "xml")
                                     (yaml-mode . "yaml")))

;TODO: Fix this or use a library instead
(defun linkode--process-response (status)
  "Given a STATUS extract location header value from response buffer."
  (let* ((status-line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (splitted (split-string status-line " "))
         (status-code (nth 1 splitted)))
    (if (string-equal status-code "201")
        (progn
          (search-forward "Location")
          (let* ((location-header (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
                 (splitted (split-string location-header " "))
                 (location-url (nth 1 splitted)))
            (kill-new location-url)
            (message (format "%s copied to clipboard" location-url))))
      (message "An error happened"))))

(defun linkode--send-snippet (type content)
  "Given a TYPE and CONTENT send a request to create snippet in Linkode."
  (let ((url-request-method "POST")
        (url-request-extra-headers
         '(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data (concat (format "text_type=%s&content=" type) (url-hexify-string content))))
    (url-retrieve linkode--url 'linkode--process-response)))

(defun linkode--send-code (code)
  "Send CODE to api."
  (let ((file-type (assoc major-mode linkode--supported-modes)))
    (if file-type
        (linkode--send-snippet (cdr file-type) code)
      (linkode--send-snippet "auto" code))))

;;;###autoload
(defun linkode-buffer ()
  "Send buffer content to linkode."
  (interactive)
  (linkode--send-code (buffer-substring-no-properties (point-min) (point-max))))

;;;###autoload
(defun linkode-region ()
  "Send region content to linkode."
  (interactive)
  (if (region-active-p)
      (linkode--send-code (buffer-substring-no-properties (region-beginning) (region-end)))
    (message "There is no active region.")))

(provide 'linkode)

;;; linkode.el ends here
