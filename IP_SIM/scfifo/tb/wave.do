onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/data
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/rdclk
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/aclr
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/rdreq
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/wrclk
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/wrreq
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/q
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/rdempty
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/wrfull
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/wrpfull
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/wroverflow
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/wrusedw
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/rdfull
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/rdusedw
add wave -noupdate /dcfifo_tb/u_dcfifo_inst/wrempty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {796453 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {8420 ns}
