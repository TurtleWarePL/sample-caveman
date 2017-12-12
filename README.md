# Sample Caveman

Honestly, this is just a tiny personal get-dirty-with-caveman2 kind of
thing. But if you really want to use it for something, go ahead. It's
a TODO list app.

## Usage

```lisp
(ql:quickload 'sample-caveman)
(sample-caveman.web::ensure-db)     ;; Bootstrap the DB (sqlite3)
(sample-caveman:start)
```

Then just go to `http://localhost:5000/` and enjoy.  Yes, it's
ugly. Yes, it operates on pure, dynamically generated HTML and is
therefore kind of wonky.
