module prompts

import term

fn print_choices(choices []string, current int) {
	for i, choice in choices {
		if i == current {
			println('${choice_current} ${term.underline(choice)}')
		} else {
			println('  ${choice}')
		}
	}
}

fn print_multichoices(choices []string, checked []int, current int) {
	for i, choice in choices {
		mut prefix := choice_unchecked
		if i in checked {
			prefix = choice_checked
		}
		mut line := '${prefix} ${choice}'
		if i == current {
			line = '${prefix} ${term.underline(choice)}'
		}
		println(line)
	}
}

fn clear_nlines(n int) {
	for _ in 0 .. n {
		term.clear_previous_line()
	}
}
