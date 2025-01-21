module main

import rand

@[heap]
struct Node {
pub mut:
	x     int
	y     int
	left  &Node = unsafe { nil }
	right &Node = unsafe { nil }
}

pub fn new_node(v int) &Node {
	mut y := rand.int()
	return &Node{
		x: v
		y: y
	}
}

struct Tree {
pub mut:
	root &Node = unsafe { nil }
}

pub fn (t &Tree) has_value(v int) bool {
	mut splitted := split(t.root, v)
	mut res := !isnil(splitted.equal)
	unsafe {
		t.root = merge3(splitted.lower, splitted.equal, splitted.greater)
	}
	return res
}

pub fn (t &Tree) insert(v int) {
	mut splitted := split(t.root, v)
	if isnil(splitted.equal) {
		splitted.equal = new_node(v)
	}
	unsafe {
		t.root = merge3(splitted.lower, splitted.equal, splitted.greater)
	}
}

pub fn (t &Tree) erase(v int) {
	mut splitted := split(t.root, v)
	unsafe {
		t.root = merge(splitted.lower, splitted.greater)
	}
}

struct SplitResult {
pub mut:
	lower   &Node = unsafe { nil }
	equal   &Node = unsafe { nil }
	greater &Node = unsafe { nil }
}

fn merge(lower &Node, greater &Node) &Node {
	if isnil(lower) {
		return greater
	}
	if isnil(greater) {
		return lower
	}
	if lower.y < greater.y {
		unsafe {
			lower.right = merge(lower.right, greater)
		}
		return lower
	}
	unsafe {
		greater.left = merge(lower, greater.left)
	}
	return greater
}

fn merge3(lower &Node, equal &Node, greater &Node) &Node {
	return merge(merge(lower, equal), greater)
}

fn split_binary(original &Node, value int) (&Node, &Node) {
	if isnil(original) {
		unsafe {
			return nil, nil
		}
	}
	if original.x < value {
		mut split_pair0, split_pair1 := split_binary(original.right, value)
		unsafe {
			original.right = split_pair0
		}
		return original, split_pair1
	}
	mut split_pair0_1, split_pair1_1 := split_binary(original.left, value)
	unsafe {
		original.left = split_pair1_1
	}
	return split_pair0_1, original
}

fn split(original &Node, value int) SplitResult {
	mut lower, equal_greater := split_binary(original, value)
	mut equal, greater := split_binary(equal_greater, value + 1)
	return SplitResult{lower, equal, greater}
}

fn main() {
	mut t := &Tree{}
	mut cur := 5
	mut res := 0
	for i := 1; i < 1000000; i++ {
		a := i % 3
		cur = (cur * 57 + 43) % 10007
		if a == 0 {
			t.insert(cur)
		} else if a == 1 {
			t.erase(cur)
		} else if a == 2 {
			if t.has_value(cur) {
				res ++
			}
		}
	}
	println(res)
}
