# latex-test

A simple unit test for my latex doc

## Requires

- `testunit`(not gem)

## Test Cases

All comment parts are ignored before testing.

  -  Are the labels correspond refs?
  -  Does figure contain 'label' definition?
  -  Does figure contain 'caption' definition?
  -  Is the figure caption placed correct position?
  -  Is the figure centering?
  -  Does table contain 'label' definition?
  -  Does table contains 'caption' definition?
  -  Is the table caption been placed correct position?
  -  Is the table centering?
  -  Does listing contain 'label' definition?
  -  Does listing contain 'caption' definition?
  -  Has the document wrote with sections?

## Run

terminal:

```
% ruby latex-test.rb input.tex
```
