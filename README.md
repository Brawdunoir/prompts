# Prompts

Beautiful interactive prompts for V. Inspired from [javascript prompts package](https://www.npmjs.com/package/prompts). 

## Demo

![demo](./assets/demo.gif)

## Examples

```c
// Basic input
input("What's your name ?")

// Hidden basic input
input_password("Type a password")!

// Yes/No question with initial response
confirm('Do you like this package ?', true)

// Single choice presented in a list
choice('What color do you prefer ?', ['Purple', 'Pink', 'Yellow', 'Blue'])

// Multi choice presented in a list
multichoice('What animals do you like ?', ['Cat', 'Dog', 'Bird'])
```

## Documentation

```c
fn choice(prompt string, choices []string) string
fn confirm(prompt string, initial bool) bool
fn input(prompt string) string
fn input_password(prompt string) !string
fn multichoice(prompt string, choices []string) []string
```
