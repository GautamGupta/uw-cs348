# BIBsearch

## Compile

```
./compile
```

## Run

```
./bibauthor AuthorName
./bibcontent PubId
./bibmaint
```

## bibauthor.sqc

 - Variables are shared between member methods using `DECLARE SECTION`
 - `main()` parses command line args and calls `print_publications()` if everything's fine
 - `print_publications()` queries for the required publications and calls `load_publication()` and `print_pub(pub_type)` on every publication returned via the SQL query
 - `load_publication()` loads the publication based on publication type into the shared variables
 - `print_pub(pub_type)` prints the publication with the respective format for `pub_type`. Calls `print_authors()` to specially handle printing authors.

## bibcontent.sqc

(Same as `bibauthor.sqc`)

 - Variables are shared between member methods using `DECLARE SECTION`
 - `main()` parses command line args and calls `print_publications()` if everything's fine
 - `print_publications()` queries for the required publications and calls `load_publication()` and `print_pub(pub_type)` on every publication returned via the SQL query
 - `load_publication()` loads the publication based on publication type into the shared variables
 - `print_pub(pub_type)` prints the publication with the respective format for `pub_type`. Calls `print_authors()` to specially handle printing authors.

## bibcontent.sqc

(Partly same as `bibauthor.sqc`)

 - Variables are shared between member methods using `DECLARE SECTION`
 - `main()` parses input and does appropriate insertion or update (for `authorurl`). It calls `print_publications()` if a publication is inserted.
 - `print_publications()` queries for the required publications and calls `load_publication()` and `print_pub(pub_type)` on every publication returned via the SQL query
 - `load_publication()` loads the publication based on publication type into the shared variables
 - `print_pub(pub_type)` prints the publication with the respective format for `pub_type`. Calls `print_authors()` to specially handle printing authors.
