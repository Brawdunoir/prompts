module prompts

import os
import term

const question_unanswered_start = term.cyan('?')
const question_answered_start = term.green('\u2713')
const question_end = term.gray('\u203a')
const dash = '─'
const choice_current = term.green('>')
const choice_checked = '[x]'
const choice_unchecked = '[ ]'
const no_initial = '[y/N]'
const yes_initial = '[Y/n]'

// input formats your prompt and uses os.input under the hood.
// as os.input, it returns '<EOF>' in case of an error (end of input).
// see os.input for more info.
pub fn input(prompt string) string {
	answer := os.input('${prompts.question_unanswered_start} ${prompt} ${prompts.question_end} ')
	term.clear_previous_line()
	println('${prompts.question_answered_start} ${prompt} ${prompts.question_end} ${term.gray(answer)}')
	return answer
}

// input_password formats your prompt and uses os.input_password under the hood.
// see os.input_password for more info.
pub fn input_password(prompt string) !string {
	answer := os.input_password('${prompts.question_unanswered_start} ${prompt} ${prompts.question_end} ')!
	term.clear_previous_line()
	println('${prompts.question_answered_start} ${prompt}')
	return answer
}

// confirm formats your prompt using the initial boolean.
pub fn confirm(prompt string, initial bool) bool {
	mut suffix := prompts.no_initial
	if initial {
		suffix = prompts.yes_initial
	}

	answer := os.input('${prompts.question_unanswered_start} ${prompt} ${term.gray(prompts.dash +
		' ' + suffix)} ')
	result := match answer.to_lower() {
		'y', 'ye', 'yes' { true }
		'n', 'no' { false }
		else { initial }
	}

	suffix = if result { 'yes' } else { 'no' }
	term.clear_previous_line()
	println('${prompts.question_answered_start} ${prompt} ${term.gray(prompts.dash + ' ' + suffix)} ')

	return result
}

// choice prints an interactive list to the user in which it can navigate.
pub fn choice(prompt string, choices []string) string {
	println('${prompts.question_unanswered_start} ${prompt} ${prompts.question_end}')
	mut i := 0
	for {
		print_choices(choices, i)
		action := interactive()
		match action {
			.done {
				break
			}
			.move_up {
				if i == 0 {
					i = choices.len - 1
				} else {
					i = (i - 1)
				}
			}
			.move_down {
				i = (i + 1) % choices.len
			}
			.nothing, .@select {}
		}
		clear_nlines(choices.len)
	}
	clear_nlines(choices.len + 1)
	println('${prompts.question_answered_start} ${prompt} ${prompts.question_end} ${term.gray(choices[i])}')
	return choices[i]
}

// multichoice prints an interactive list to the user in which it can select multiple choices.
pub fn multichoice(prompt string, choices []string) []string {
	println('${prompts.question_unanswered_start} ${prompt} ${prompts.question_end}')
	mut i := 0
	mut checked := []int{len: choices.len, cap: choices.len, init: choices.len}
	mut result := []string{cap: choices.len}
	for {
		print_multichoices(choices, checked, i)
		action := interactive()
		match action {
			.done {
				break
			}
			.move_up {
				if i == 0 {
					i = choices.len - 1
				} else {
					i = (i - 1)
				}
			}
			.move_down {
				i = (i + 1) % choices.len
			}
			.@select {
				if i in checked {
					checked.delete(i)
				} else {
					checked.insert(i, i)
				}
			}
			.nothing {}
		}
		clear_nlines(choices.len)
	}
	for j, choice in choices {
		if j in checked {
			result << choice
		}
	}
	clear_nlines(choices.len + 1)
	println('${prompts.question_answered_start} ${prompt} ${prompts.question_end} ${term.gray(result.str())}')
	return result
}
