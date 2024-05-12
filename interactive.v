// based on the work of Alexander Medvednikov on the readline module https://github.com/vlang/v
module prompts

import readline

enum Action {
	move_up
	move_down
	done
	nothing
	@select
}

fn interactive() Action {
	mut rl := readline.Readline{}
	for {
		rl.enable_raw_mode_nosig()
		c := rl.read_char() or { panic('Control sequence incomplete') }
		rl.disable_raw_mode()
		match c.hex() {
			'41', '44', '6b', '68' { return .move_up } // up arrow, left arrow, k and h
			'42', '43', '6a', '6c' { return .move_down } // down arrow, right arrow, j and l
			'20', '9' { return .@select } // space, tab
			'd' { return .done } // enter
			else { return .nothing }
		}
	}
}
