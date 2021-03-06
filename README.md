# Overview

This project converts a custom markdown file to a `.tsv` file that is recognized
 by the Anki App.

## Terminology

- _System Tag_ - it is the actual tag used by the anki app to categorize
 the cards.
- _Display Tag_ - it is hard coded into the card html to quick visibility.  It
 adds important, relative information to the card content.
- File _base name_ - it is the simple filename without the last extension.  e.g.
 `file.txt.bak` => `file.txt`
- _card block_ - it is the line(s) of text that will appear on one side of a card.

## Setup

Set environment variables in .env

### Ruby version

Use at least 2.4 as 2.3 throws an exception around `match` method being improperly used.

## Running

See Rakefile for complete list of commands.


### Notable Codes

highlighter_none.rb

- Regexp matching an empty string.
- Nestable Regular Expression parse and extract
- Lots of regular expressions!
- oop_utils.rb - determines calling method name
- Nested DSLs, HTML DSL(Customized from other's github code)
- RSpec
- Spec Maker (tweaked from someone else's github code)

File uploading is broken at the moment to the point where the final button is
 disabled to be pressed.

### Issues

- Highlighting style should be card side independent.
- Support for highlighting theme.
- Running the upload runs into error if you have selenium 3.x gem.

## Testing

**Notes: **

"#instance_method"
".static_method"

### How to run all Tests with coverage

```bash
rspec -fd
```

### Test a single file

```bash
rspec spec/utils/html_utils_spec.rb
```

**Note**: Logging needs to be set to `WARN` for it to be logged.

Coverage at: `coverage/index.html#_AllFiles`
