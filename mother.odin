package main

import "base:runtime"
import "core:fmt"
import "core:strconv"
import "core:slice"
import "core:math/rand"
import "core:math/noise"
import "core:math/linalg"
import "core:math"
import "core:strings"
import hla "collections/hollow_array"
import rl "vendor:raylib"

Mother :: struct {
	using _ : Building,
	_hitpoint_last : int,
	_recover_timer : f64,
}

@private
_Mother_VTable :Building_VTable(Mother)= {
	update = proc(m: ^Mother, delta: f64) {
		if m._recover_timer > 0 {
			m._recover_timer -= delta
		}
		if m._hitpoint_last <= m.hitpoint {
			if m._recover_timer <= 0 {
				m.hitpoint += 10
				m.hitpoint = math.min(m.hitpoint, m.hitpoint_define)
				m._recover_timer = 1
			}
		} else {
			m._recover_timer = 3
		}
		m._hitpoint_last = m.hitpoint
	},
	init = proc(m: ^Mother) {
		m.powered = -1
		m._hitpoint_last = m.hitpoint
	},
	release = proc(m: ^Mother) {
		game.dead = true
	},
	pre_draw = auto_cast Building_VTable_Empty.pre_draw,
	draw = proc(m: ^Mother) {
		tex := game.res.mother_tex
		height := cast(f32) tex.height
		src, dst :rl.Rectangle= {0,0,32, height}, {cast(f32)m.position.x,cast(f32)m.position.y, 1, height/32.0}
		frame :f32= 0.04
		rl.DrawTexturePro(tex, src, {dst.x, dst.y+frame, dst.width, dst.height}, {0,0}, 0, rl.BLACK)
		rl.DrawTexturePro(tex, src, {dst.x, dst.y-frame, dst.width, dst.height}, {0,0}, 0, rl.BLACK)
		rl.DrawTexturePro(tex, src, {dst.x+frame, dst.y, dst.width, dst.height}, {0,0}, 0, rl.BLACK)
		rl.DrawTexturePro(tex, src, {dst.x-frame, dst.y, dst.width, dst.height}, {0,0}, 0, rl.BLACK)
		rl.DrawTexturePro(tex, src, dst, {0,0}, 0, rl.WHITE)
	},
	extra_draw = proc(m: ^Mother) {
		draw_building_hpbar(m)
	},
	_is_place_on_water = proc() -> bool {
		return false
	},
	_define_hitpoint = proc() -> int { return 600 }
}
