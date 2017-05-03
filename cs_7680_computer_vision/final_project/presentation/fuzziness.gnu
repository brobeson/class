#set terminal wxt size 350,262 enhanced font 'Verdana,10' persist
set terminal wxt size 400,400 enhanced font 'Verdana,10' persist
set key at 0.6,0.9
#set border linewidth 1.5
#set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2
#set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 2
set xlabel '{/Symbol D}'
set ylabel 'f({/Symbol D})'
set xrange [0 : 1]
set yrange [0 : 1]
#set xtics ('-2pi' -2 * pi, '-pi' -pi, 0, 'pi' pi, '2pi' 2 * pi)
#set ytics 1
#set tics scale 0.75
#set key at 6.1, 1.3

#a = 0.9
#f(x) = a * sin(x)
#g(x) = a * cos(x)
#plot f(x) title 'sin(x)' with lines linestyle 1, \
#     g(x) notitle with lines linestyle 2

set size square

f(x) = x
g(x) = 3 * x**2 - 2 * x**3
plot f(x) title 'f({/Symbol D}) = {/Symbol D}' with lines linestyle 1, \
     g(x) title 'f({/Symbol D}) = (3{/Symbol D}^2-2{/Symbol D}^3)' with lines linestyle 2

#set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5
#set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5
#plot 'scatter.dat' index 0 with points ls 1 notitle, \
#     ''            index 1 with points ls 2 notitle


# plot some classes
#unset key
#set size ratio -1
#set xrange [-2.5:1.5]
#set yrange [-1:2.5]
#plot 'interclass_scatter.dat' index 0 with circles lc rgb "blue" fs solid 1.0 noborder notitle, \
#     '' index 1 with circles lc rgb "red" fs solid 1.0 noborder notitle, \
#     '' index 2 with circles lc rgb "blue" fs solid 1.0 noborder notitle, \
#     '' index 3 with circles lc rgb "red" fs solid 1.0 noborder notitle
