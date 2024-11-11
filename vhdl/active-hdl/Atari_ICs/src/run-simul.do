@onerror
{
goto end
}

setactivelib -work
acom -2002 -work freddie "$dsn\src\freddie.vhd"
acom -2002 -work freddie "$dsn\src\tb_freddie.vhd"
asim +access +r +m+freddie_tb freddie_tb
wave
wave  /freddie_tb/* .freddie_tb.*
run 2800ns
endsim

label end

