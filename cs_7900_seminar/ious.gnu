#set terminal wxt size 350,262 enhanced font 'Verdana,10' persist
set terminal wxt size 800,400 enhanced font 'Verdana,10' persist
set key at 60,0.1
#set border linewidth 1.5
#set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2
#set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 2
set xlabel 'frame'
set ylabel 'IoU'
set xrange [0 : 73]
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

#set size square

#f(x) = 1 - x
#g(x) = 1 - 3 * x**2 + 2 * x**3
#b = 0.65
#h(x) = 1 - x**(log(b) / log(0.5))
#plot f(x) title '1-x' with lines linestyle 1, \
#     g(x) title '1-(3x^2-2x^3)' with lines linestyle 2, \
#     h(x) title 'Bias_{0.65}' with lines linestyle 3

#set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5
#set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5
plot 'tiger1_original.ious' index 0 with lines ls 1 title 'Struck', \
     'tiger1_fuzzy.ious' index 0 with lines ls 2 title 'Weighted'
#plot 'tiger1_original.ious' index 0 with points ls 1 notitle, \
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
